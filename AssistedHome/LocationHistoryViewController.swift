//
//  LocationHistoryViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 09/04/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var locationHistoryTableView: UITableView!
    
    var locationStrings = [String]()
    
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
            performSegue(withIdentifier: "RemindersToHome", sender: self)
        }
    }
    
    // Declare number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Table view stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(LocationHistory.addressStrings.count)
        return LocationHistory.addressStrings.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = LocationHistory.addressStrings[indexPath.row]
        print(LocationHistory.addressStrings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        
        // Set struct value to index path
        //Events.eventIndex = indexPath.row
        
       // self.performSegue(withIdentifier: "ReminderToDetailed", sender: self)
    }
    
//    // Build address object
//    func buildAddress(){
//        for location in LocationHistory.locationHistory {
//            let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//
//            reverseLocationLookup(for: clLocation) { placemark in
//                guard let placemark = placemark else { return }
//
//                let address = placemark.createAddressString()
//
//                self.locationStrings.append(address)
//
//                print(address)
//        }
//    }
//}
//
//    // Reverse location lookup
//    func reverseLocationLookup(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void){
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location){
//            placemarks, error in
//            guard error == nil else {
//                print("Error")
//                completion(nil)
//                return
//
//            }
//            guard let placemark = placemarks?[0] else {
//                print("Placemark is nil")
//                completion(nil)
//                return
//            }
//            completion(placemark)
//
//        }
//    }
    
    override func viewDidLoad() {
        
        // Add support for swipe gestures
        addSwipes()
        
        // Set background gradient
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        // Set data source and delegates for table view
        locationHistoryTableView.dataSource = self
        locationHistoryTableView.delegate = self
        locationHistoryTableView.reloadData()
    }
}
