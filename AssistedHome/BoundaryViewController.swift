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

class BoundaryViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    
        
        // Adding Gesture Recogniser to mapView
        let gestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecogniser.delegate = self
        mapView.addGestureRecognizer(gestureRecogniser)
        
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegion.init(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
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
            let viewRegion = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
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
                print("Error in function" )
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
        let location = gestureRecogniser.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Converting 2d location to CLLocation
        let locationTitle = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Call reverse location lookup
        reverseLocationLookup(for: locationTitle) { placemark in
            guard let placemark = placemark else { return }
            
            print(placemark)
            
           let address =  placemark.createAddressString()
            
            
            let reuseId = "pin"
            var pinView = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            // Add annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Dropped pin"
            annotation.subtitle = address
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
            }
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure) as UIButton
            
        self.mapView.addAnnotation(annotation)
    }
        
    }
}
