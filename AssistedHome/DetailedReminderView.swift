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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // Localise event titles
    var eventTitles = Events.eventTitles
    
    @IBOutlet weak var DetailedMapView: MKMapView!
    
    // Localise coordinates
    var coorinates = Events.coorindates
    
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
    
    // Add support for swipe gestures
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
            performSegue(withIdentifier: "DetailedToListView", sender: self)
        }
    }
    
    
    func formatDateStrings(date: Date) -> String {
        let formatter        = DateFormatter()
        formatter.dateFormat = "EEEE MMM d, yyyy @ HH:mm"
        let formattedString  = formatter.string(from: date)
        
        return formattedString
    }
    
    override func viewDidLoad(){
        
        DetailedMapView.layer.cornerRadius = 10.0
    
        addSwipes()
        
        let locationManager             = CLLocationManager()
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        for n in 0...localLocations.count{
            if Events.eventIndex == n {
                print("Location string at event index \(localLocations[n])")
                locationLabel.text = localLocations[n]
                timeLabel.text     = formatDateStrings(date: Events.eventTime[n])
                
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
                annotation.title      = eventTitles[n]
                
                titleLabel.text = "- \(eventTitles[n])'s details -"
                
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
    }
}
