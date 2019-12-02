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
    
    @objc func handleTap(gestureRecogniser: UILongPressGestureRecognizer){
        let location = gestureRecogniser.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}
