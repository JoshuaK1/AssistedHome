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
import EventKit

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
        
         self.requestAccessToCelandar()
        
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
    
     // Functions for calendar
    
    var model = [EventData]()
    
    func fetchCalendarEvents(calendarTitle: String) -> Void {
        let calendars = eventStore.calendars(for: .event)
        
        for calendar:EKCalendar in calendars {
            
            if calendar.title == calendarTitle {
                
                let selectedCalendar = calendar
                let startDate = NSDate(timeIntervalSinceNow: -60*60*24*180)
                let endDate = NSDate(timeIntervalSinceNow: 60*60*24*180)
                let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [selectedCalendar])
                let addedEvents = eventStore.events(matching: predicate) as [EKEvent]
                
                
                print("addedEvents : \(addedEvents)")
                
                
                for event in addedEvents {
                    
                    // Get long and lat from calendar Event
                    let latitude = event.structuredLocation?.geoLocation?.coordinate.latitude
                    let longtitude = event.structuredLocation?.geoLocation?.coordinate.longitude
                    
                    // Build coordinate
                    let coordinate = CLLocationCoordinate2DMake(latitude!, longtitude!)
                    
                    // Add to coordiante array struct
                    Events.coorindates.append(coordinate)
                    
                    print(latitude!)
                    print(longtitude!)
                    
                    Events.locationStrings.append(event.location!)
                    Events.eventTitles.append(event.title!)
                    print("Location has been added", event.location!)
                    
                }
            }
        }
    }
    
    // initialise event store
    let eventStore = EKEventStore()
    
    // function to fetch events from calendar
    func fetchCalendarEvents() -> Void{
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch(status){
        case .notDetermined:
            requestAccessToCelandar()
        case .authorized:
            self.fetchCalendarEvents(calendarTitle: "AssistedHome")
            break
        case .restricted, .denied:
            print("Access to calendar is not permitted")
            // Alert to prompt user to grant access to calendar
            break
        }
        
    }
    
   
    func requestAccessToCelandar(){
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            // call fetch events
            self.fetchCalendarEvents()
        }
        
    }
    
    
}

