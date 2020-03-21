//
//  GPSViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 13/01/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class GPSViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var CurrentDeviceLocation: MKMapView!
    
    
    //Add Support for swipe gestures
    func addSwipes(){
        let directions:[UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
        
    }
    
    //Handle swipe gestures
    @objc func handleSwipes(sender: UISwipeGestureRecognizer){
        if sender.direction == .right{
            performSegue(withIdentifier: "GPSViewToHomeView", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        addSwipes()
        
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegion.init(center: noLocation,
                                                 latitudinalMeters: 200,
                                                 longitudinalMeters: 200)
        
        CurrentDeviceLocation.setRegion(viewRegion, animated: true)
        
        let locationManager             = CLLocationManager()
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Check if location services are enabled
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        
        // Zoom to current user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion  = MKCoordinateRegion.init(center: userLocation,
                                                      latitudinalMeters: 200,
                                                      longitudinalMeters: 200)
            
            CurrentDeviceLocation.setRegion(viewRegion, animated: false)
        }
        
        DispatchQueue.main.async {
            locationManager.startUpdatingLocation()
        }
        
        // show current user location
        locationManager.requestWhenInUseAuthorization()
        
        CurrentDeviceLocation.mapType           = .standard
        CurrentDeviceLocation.showsUserLocation = true
        CurrentDeviceLocation.showsScale        = true
    }
    


}
