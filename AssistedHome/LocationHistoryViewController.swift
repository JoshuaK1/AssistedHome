//
//  LocationHistoryViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 09/04/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit

class LocationHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var locationHistoryTableView: UITableView!
    
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
//        print(eventIdentifiers.count)
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
//        cell.textLabel?.text = eventIdentifiers[indexPath.row]
//        cell.detailTextLabel?.text = locations[indexPath.row]
//        print(locations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        
        // Set struct value to index path
        //Events.eventIndex = indexPath.row
        
       // self.performSegue(withIdentifier: "ReminderToDetailed", sender: self)
    }
    
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
