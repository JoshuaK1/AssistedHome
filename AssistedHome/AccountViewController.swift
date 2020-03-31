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
        
        // Set data source for table view
        EventTableView.dataSource = self
        EventTableView.delegate = self
        EventTableView.reloadData()

    }
    

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
   
}
