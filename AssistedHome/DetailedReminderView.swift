//
//  DetailedReminderView.swift
//  AssistedHome
//
//  Created by Joshua Knight on 31/03/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class DetailedReminderView: UIViewController, CLLocationManagerDelegate {
    
    // localise location strings
    var localLocations = Events.locationStrings
    
    @IBOutlet weak var DetailedMapView: MKMapView!
    
    // Localise coordinates
    var coorinates = Events.coorindates
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var IndexLabel: UILabel!
    
    func setMapLocation(){
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegion.init(center: noLocation,
                                                 latitudinalMeters: 200,
                                                 longitudinalMeters: 200)

        DetailedMapView.setRegion(viewRegion, animated: true)
        }
    
    func setViewRegion(viewRegion: MKCoordinateRegion){
        DetailedMapView.setRegion(viewRegion, animated: false)

    }
    
    override func viewDidLoad() {
        let locationManager             = CLLocationManager()
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        for n in 0...localLocations.count{
            if Events.eventIndex == n {
                print("Location string at event index \(localLocations[n])")
                locationLabel.text = localLocations[n]
            }
        }
        
        for n in 0...coorinates.count{
            if Events.eventIndex == n {
                let viewRegion  = MKCoordinateRegion.init(center: coorinates[n],
                                                          latitudinalMeters: 200,
                                                          longitudinalMeters: 200)
                
                setViewRegion(viewRegion: viewRegion)
                
                // Add annotation to map view
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = coorinates[n]
                annotation.title      = localLocations[n]
                
                self.DetailedMapView.addAnnotation(annotation)
                
            }

            // Update map on the main queue
            DispatchQueue.main.async {
                locationManager.startUpdatingLocation()
            }
            
            DetailedMapView.mapType           = .standard
            DetailedMapView.showsUserLocation = true
            DetailedMapView.showsScale        = true
        
        }
        
        // Check values in array have been passed through
        for location in localLocations {
            print("Location is \(location)")
        }
        IndexLabel.text = "Value passed through is \(Events.eventIndex) "
    }
}
