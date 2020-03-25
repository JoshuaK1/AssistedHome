//
//  HomeViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 24/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import UserNotifications

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var menuShowing = false
    
    // Database reference
    let ref = Database.database().reference(withPath: "userRef")
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var AccountView: UIView!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var DateLabelTwo: UILabel!
    @IBOutlet weak var DateLabelOne: UILabel!
    @IBOutlet weak var GPSButton: UIButton!
    @IBOutlet weak var GPSHistoryButton: UIButton!
    @IBOutlet weak var BoundaryButton: UIButton!
    @IBOutlet weak var AnnouncementsButton: UIButton!
    @IBOutlet weak var AlertsButton: UIButton!
    @IBOutlet weak var RemindersButton: UIButton!
    @IBOutlet weak var AccountViewButton: UIButton!
    
    
    @IBAction func AccountViewButton(_ sender: Any) {
        performSegue(withIdentifier: "HomeToAccount", sender: self)
        
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        performSegue(withIdentifier: "LogoutToHome", sender: self)
    }
    
    
    @IBAction func AccountShow(_ sender: Any) {
        if (menuShowing){
            LeadingConstraint.constant = -230
            UIView.animate(withDuration: 0.2, delay: 0.0, options:.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            LeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options:.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                })
        }
        menuShowing = !menuShowing
    }
    
    
    
    @IBAction func GPSButton(_ sender: Any) {
        performSegue(withIdentifier: "GPSButtonToGPSView", sender: self)
    }
    
    @IBAction func announceButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToAnnounce", sender: self)
    }
    @IBAction func boundaryButton(_ sender: Any) {
        performSegue(withIdentifier: "HomeToBoundary", sender: self)
    }
    
    // Function to set user reference in Firebase
    func setUserRef(){
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() {
                return
                
            }
            let username = snapshot.childSnapshot(forPath: "UID").value
            print("UID taken from firebase" , username!)
            
        })
    }
    
    func timeLabel(){
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        let timeString = "\(dateFormatter.string(from: Date() as Date))"
        
        TimeLabel.text = String(timeString)
        
        
    }
    
    func dateLabel(){
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        let month = Calendar.current.component(.month, from: today)
        let date = Calendar.current.component(.day, from: today)
        
        DateLabelOne.text = Calendar.current.weekdaySymbols[weekday-1]
        DateLabelTwo.text = "| \(Calendar.current.shortMonthSymbols[month-1]) \(date)"
    }
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    // Functions for enterring and exiting regions
    
    override func viewDidLoad() {
        
        // Notitifications when enter and exit a geofence
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        locationManager.distanceFilter = 100
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(54.687353, -5.882736), radius: 100, identifier: "TestLocation")
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
        AccountView.roundCornerView(cornerRadius: 10)
        
        setUserRef()
        dateLabel()
        timeLabel()
        
        LeadingConstraint.constant = -230
        
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        AccountView.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        
        GPSButton           .setHomeButtonStyles()
        GPSHistoryButton    .setHomeButtonStyles()
        BoundaryButton      .setHomeButtonStyles()
        AnnouncementsButton .setHomeButtonStyles()
        AlertsButton        .setHomeButtonStyles()
        RemindersButton     .setHomeButtonStyles()
        
        
    }
    
    func postLocalNotifications(eventTitle:String, body: String){
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        
        content.title = eventTitle
        content.body  = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let notificationRequest: UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        
        notificationCenter.add(notificationRequest, withCompletionHandler: {(error) in
            if let error = error {
                print (error)
            } else {
                print("Notification added")
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion){
        print("Entered: \(region.identifier)")
        
        let body = "User has arrived at the above safe zone"
        
        postLocalNotifications(eventTitle: region.identifier, body: body)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion){
        print("Exited: \(region.identifier)")
        
        let body = "User has left the above safe zone"

        postLocalNotifications(eventTitle: region.identifier, body: body)
    }
}

