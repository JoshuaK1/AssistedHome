//
//  BoundaryViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 02/12/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Contacts
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

class BoundaryViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var boundaries: [MKPointAnnotation] = []
    
    // Firebase database reference
     var ref: DatabaseReference!
    
    // userRef Datatbase reference
    let userRef = Database.database().reference(withPath: "userRef")
    
    // Post user boundaries to firebase
    func postUserBoundaries(annotations: [MKPointAnnotation], userID: String){
        for anno in annotations {
            
            let boundaryTitle      = anno.title
            let boundarySubtitle   = anno.subtitle
            let boundaryLatitude   = String(format: "%f", anno.coordinate.latitude)
            let boundaryLongtitude = String(format: "%f", anno.coordinate.longitude)
            
            print(boundaryTitle!)
            print(boundarySubtitle!)
            print(boundaryLatitude)
            print(boundaryLongtitude)
            
            // Post Data to Firebase
            
            let boundaryRef    = Database.database().reference(withPath: "boundaries")
            let userBoundaries = boundaryRef.child(userID)
            
            let boundary = userBoundaries.child(boundarySubtitle!)
            boundary.child("latitude")   .setValue(boundaryLatitude)
            boundary.child("longtitude") .setValue(boundaryLongtitude)
            boundary.child("subTitle")   .setValue(boundarySubtitle!)
            boundary.child("title")      .setValue(boundaryTitle!)
            
            // Change Longtitdue and latitude strings to doubles
            let latitudeDouble  = NumberFormatter().number(from: boundaryLatitude)?.doubleValue
            let longtitdeDouble = NumberFormatter().number(from: boundaryLongtitude)?.doubleValue
            
            // Start monitoring for locations
            let locationManager: CLLocationManager = CLLocationManager()
            
            locationManager.delegate = self
            
            locationManager.startUpdatingLocation()
            
            locationManager.distanceFilter = 100
            
            let geoFencingRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(latitudeDouble!, longtitdeDouble!), radius: 100, identifier: boundarySubtitle!)
            
            locationManager.startMonitoring(for: geoFencingRegion)
            
            // Call function to add monitored region
//            self.postLocalNotifications(eventTitle: boundarySubtitle!)
        }
        
    }
    
    // Add Support for swipe gestures
    func addSwipes(){
        let directions:[UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
        
    }
    
    // Handle Swipe Gestures
    @objc func handleSwipes(sender: UISwipeGestureRecognizer){
        if sender.direction == .right{
            performSegue(withIdentifier: "MapViewToHome", sender: self)
        }
    }
    
    // Set properties for map views
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {return nil}
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            
            let deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            deleteButton.setImage(UIImage(named: "icons8-delete-bin-64.png"), for: .normal)
            
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.rightCalloutAccessoryView = deleteButton
            pinView!.canShowCallout            = true
            pinView!.animatesDrop              = true
            pinView!.isDraggable               = true
            pinView!.sizeToFit()
            
        } else {
            pinView!.annotation = annotation
            
        }
        return pinView
        
    }
    
    // Remove single annotation from map
    func removeSingleAnnotation(annoTitle: String){
        for annotation in self.mapView.annotations {
            let title = annotation.subtitle
            if title == annoTitle {
                self.mapView.removeAnnotation(annotation)
                
            }
        }
    }
    
    
    // Callout button on annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let annotationTitle = view.annotation?.subtitle
            removeSingleAnnotation(annoTitle: annotationTitle!!)
            
            print("Annotation title is", annotationTitle!!)
            
            removeBoundary(key: annotationTitle!!)
        }
    }
    
    // Remove boundary from map view
    func removeBoundary(key: String){
        
        let boundaryToRemove = key
        
        // Set firebase reference
        
        let userID        = Auth.auth().currentUser?.uid
        let boundaryRef   = Database.database().reference(withPath: "boundaries")
        let uidRef        = boundaryRef.child(userID!)
        let lowerBoundary = uidRef.child(key)
        
        // Get values from firebase snapshot
        lowerBoundary.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let boundarySubtitle = value?["subTitle"] as? String ?? ""
            
            print("from removeBoundary method", boundarySubtitle)
            print("Boundary to remove", boundaryToRemove)
            
            // Logic to ensure the correct boundary is removed
            if(boundarySubtitle == boundaryToRemove){
                lowerBoundary.setValue(nil)
                
            }
        })
        
    }
    
    // Add monitored region
//    func postLocalNotifications(eventTitle: String){
//        let notificationCenter = UNUserNotificationCenter.current()
//
//        let content = UNMutableNotificationContent()
//
//        content.title = eventTitle
//        content.body  = "User has exceeded the boundary"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//
//        let notificationRequest: UNNotificationRequest = UNNotificationRequest(identifier: eventTitle, content: content, trigger: trigger)
//
//        notificationCenter.add(notificationRequest,withCompletionHandler: {(error) in
//            if let error = error {
//                print (error)
//            } else {
//                print("Notification added")
//            }
//        })
//    }

//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion){
//        print("Entered: \(region.identifier)")
//
//        postLocalNotifications(eventTitle: region.identifier)
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion){
//        print("Exited: \(region.identifier)")
//
//        postLocalNotifications(eventTitle: region.identifier)
//    }
    
    // Add boundaries to map view
    func addBoundaries(key: String){
        
        // Set firebase references
        let userID        = Auth.auth().currentUser?.uid
        let boundaryRef   = Database.database().reference(withPath: "boundaries")
        let uidRef        = boundaryRef.child(userID!)
        let lowerBoundary = uidRef.child(key)
        
        // Get values from firebase snapshot
        lowerBoundary.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let boundaryTitle      = value?["title"]      as? String ?? ""
            let boundarySubttile   = value?["subTitle"]   as? String ?? ""
            let boundaryLongtitude = value?["longtitude"] as? String ?? ""
            let boundaryLatitude   = value?["latitude"]   as? String ?? ""
            
            print("from addBoundaries method", boundaryTitle)
            print("from addBoundaries method", boundarySubttile)
            print("from addBoundaries method", boundaryLongtitude)
            print("from addBoundaries method", boundaryLatitude)
            
            // Create annotation to add to map view
            let annotation = MKPointAnnotation()
            
            // Change Longtitdue and latitude strings to doubles
            let latitudeDouble  = NumberFormatter().number(from: boundaryLatitude)?.doubleValue
            let longtitdeDouble = NumberFormatter().number(from: boundaryLongtitude)?.doubleValue
            
            var coordinate = CLLocationCoordinate2D()
            
            
            coordinate.latitude  = latitudeDouble!
            coordinate.longitude = longtitdeDouble!
            
            annotation.coordinate = coordinate
            annotation.title      = boundaryTitle
            annotation.subtitle   = boundarySubttile
            
            self.mapView.addAnnotation(annotation)
        
        })
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        // UserID each time view loads
          let userID = Auth.auth().currentUser?.uid
        
        // Pull down annotation data
        let boundaryRef = Database.database().reference(withPath: "boundaries")
        let uidRef      = boundaryRef.child(userID!)
        
        uidRef.observeSingleEvent(of: .value, with: {(snapshot) in
            for value in snapshot.children {
                let key = (value as AnyObject).key as String
                print(key)
                
                // Function call to add boundaries
                self.addBoundaries(key: key)
                
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        //Checking current user ID
        let userID = Auth.auth().currentUser?.uid
        print(userID!)
        
       self.mapView.addAnnotations(boundaries)
        
        addSwipes()
        
        // Adding Gesture Recogniser to mapView
        let gestureRecogniser      = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecogniser.delegate = self
        mapView.addGestureRecognizer(gestureRecogniser)
        
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegion.init(center: noLocation,
                                                 latitudinalMeters: 200,
                                                 longitudinalMeters: 200)
        
        mapView.setRegion(viewRegion, animated: false)
        
        let locationManager             = CLLocationManager()
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check if Location Services are enabled
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        
        // Zoom to current user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion  = MKCoordinateRegion.init(center: userLocation,
                                                      latitudinalMeters: 200,
                                                      longitudinalMeters: 200)
            
            mapView.setRegion(viewRegion, animated: false)
        }
        
        DispatchQueue.main.async {
            locationManager.startUpdatingLocation()
        }
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        mapView.layer.cornerRadius = 8.0
        
        // show current user location
        locationManager.requestWhenInUseAuthorization()
        
        mapView.mapType           = .standard
        mapView.showsUserLocation = true
        mapView.showsScale        = true
        
    }
    
    // Function to lookup address from coordinate
    func reverseLocationLookup(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location){
            placemarks, error in
            guard error == nil else {
                print("Error")
                completion(nil)
                return
                
            }
            guard let placemark = placemarks?[0] else {
                print("Placemark is nil")
                completion(nil)
                return
            }
            completion(placemark)
            
        }
    }
    
    @objc func handleTap(gestureRecogniser: UILongPressGestureRecognizer){
        
        // Don't generate multiple pins
        if gestureRecogniser.state != UIGestureRecognizer.State.began {
            return
        }
        
        let location   = gestureRecogniser.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Converting 2d location to CLLocation
        let locationTitle = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Call reverse location lookup
        reverseLocationLookup(for: locationTitle) { placemark in
            guard let placemark = placemark else { return }
            
            print(placemark)
            
           let address = placemark.createAddressString()
            
            // Add annotation
            let annotation        = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title      = "Boundary Pin"
            annotation.subtitle   = address
            
            
        self.mapView.addAnnotation(annotation)
        self.boundaries.append(annotation)
        print(self.boundaries.count)
            
             // Get current user ID
            let userID = Auth.auth().currentUser?.uid
            
            // Pass through to post method
            self.postUserBoundaries(annotations: self.boundaries, userID: userID!)
        
    }
  }
}
