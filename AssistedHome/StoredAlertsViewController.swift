//
//  StoredAlertsViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 09/04/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StoredAlertsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var retrievedAlerts = [String]()
    
    // Table view stubs
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Table view stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(StoredAlerts.storedAlerts.count)
        return StoredAlerts.storedAlerts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = StoredAlerts.storedAlerts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        
        //self.performSegue(withIdentifier: "ReminderToDetailed", sender: self)
    }
    
    @IBOutlet weak var storedAlertsTableView: UITableView!
    
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
            performSegue(withIdentifier: "alertsToHome", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Obtain data from firebase
        //self.obtainKeys()
    }
    
    override func viewDidLoad() {
        //self.obtainKeys()
        // Set background gradient
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        addSwipes()
        
        storedAlertsTableView.dataSource = self
        storedAlertsTableView.delegate = self
        
        for alert in StoredAlerts.storedAlerts {
            print(alert)
        }
    }
}
