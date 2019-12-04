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

class BoundaryViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var boundaries: [MKPointAnnotation] = []
    
    // Firebase database reference
     var ref: DatabaseReference!
    
    // userRef Datatbase reference
    let userRef = Database.database().reference(withPath: "userRef")
    
    // function to post user specific boundaries to firebase
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
            
            let boundaryRef = Database.database().reference(withPath: "boundaries")
            
            let userBoundaries = boundaryRef.child(userID)
            
            let boundary = userBoundaries.child(boundarySubtitle!)
            boundary.child("latitude").setValue(boundaryLatitude)
            boundary.child("longtitude").setValue(boundaryLongtitude)
            boundary.child("subTitle").setValue(boundarySubtitle!)
            boundary.child("title").setValue(boundaryTitle!)
        }
        
    }
    
    // Add Swipe Gestures
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
    
    // Function
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {return nil}
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.canShowCallout            = true
            pinView!.animatesDrop              = true
            pinView!.isDraggable               = true
            pinView!.sizeToFit()
            
        } else {
            pinView!.annotation = annotation
            
        }
        return pinView
        
    }
    
    // Function to remove single annotation
    func removeSingleAnnotation(annoTitle: String){
        for annotation in self.mapView.annotations {
            let title = annotation.subtitle
            if title == annoTitle {
                self.mapView.removeAnnotation(annotation)
                
            }
        }
    }
    
    
    // Function for Button
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let annotationTitle = view.annotation?.subtitle
            removeSingleAnnotation(annoTitle: annotationTitle!!)
            
        }
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
