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

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var locations = Events.locationStrings
    var eventIdentifiers = Events.eventTitles
    
    override func viewDidLoad() {
        
        // call requestAccess to Calendar
      //  self.requestAccessToCelandar()
        
        // Set data source for table view
        EventTableView.dataSource = self
        EventTableView.delegate = self
        EventTableView.reloadData()

    }
    
//    func fetchCalendarEvents(calendarTitle: String) -> Void {
//        let calendars = eventStore.calendars(for: .event)
//
//        for calendar:EKCalendar in calendars {
//
//            if calendar.title == calendarTitle {
//
//                let selectedCalendar = calendar
//                let startDate = NSDate(timeIntervalSinceNow: -60*60*24*180)
//                let endDate = NSDate(timeIntervalSinceNow: 60*60*24*180)
//                let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [selectedCalendar])
//                let addedEvents = eventStore.events(matching: predicate) as [EKEvent]
//
//
//                print("addedEvents : \(addedEvents)")
//
//
//                for event in addedEvents {
//                    let eventData = EventData(location: event.location!)
//                    model.append(eventData)
//
//                }
//            }
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Table view stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(eventIdentifiers.count)
        return eventIdentifiers.count
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = eventIdentifiers[indexPath.row]
        print(indexPath.row)
        return cell
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBOutlet weak var EventTableView: UITableView!
    
    
    // initialise event store
//    let eventStore = EKEventStore()
//
//    // function to fetch events from calendar
//    func fetchCalendarEvents() -> Void{
//        let status = EKEventStore.authorizationStatus(for: .event)
//
//        switch(status){
//        case .notDetermined:
//            requestAccessToCelandar()
//        case .authorized:
//            self.fetchCalendarEvents(calendarTitle: "AssistedHome")
//            break
//        case .restricted, .denied:
//            print("Access to calendar is not permitted")
//            // Alert to prompt user to grant access to calendar
//            break
//        }
//
//    }
//

//    func requestAccessToCelandar(){
//        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
//            // call fetch events
//            self.fetchCalendarEvents()
//        }
//
//    }
   
}
