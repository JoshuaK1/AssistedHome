//
//  AccountViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 20/03/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class AccountViewController: UIViewController {
    
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
    
    func fetchCalendarEvents(calendarTitle: String) -> Void {
        let calendars = eventStore.calendars(for: .event)
        
        for calendar:EKCalendar in calendars {
            
            if calendar.title == calendarTitle {
                
                let selectedCalendar = calendar
                let startDate = NSDate(timeIntervalSinceNow: -60*60*24*180)
                let endDate = NSDate(timeIntervalSinceNow: 60*60*24*180)
                let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [selectedCalendar])
                let addedEvents = eventStore.events(matching: predicate) as [EKEvent]
                
               // print("addedEvents : \(addedEvents)")
                
                // loop through events and print location data
                for event in addedEvents {
                    print(event.location!)
                }
                
            }
        }
        
        
    }
    
    func requestAccessToCelandar(){
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            
            // call fetch events
            self.fetchCalendarEvents()
        }
        
    }
    
   
    override func viewDidLoad() {

        // call requestAccess to Calendar
        
        self.requestAccessToCelandar()
        
    }

}
