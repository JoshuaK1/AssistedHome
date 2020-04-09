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

class StoredAlertsViewController: UIViewController{
    
    @IBOutlet weak var storedAlertsTableView: UITableView!
    
    func obtainKeys(){
        
        // Grab user ID
        let userID = Auth.auth().currentUser?.uid
        
        let alertRef = Database.database().reference(withPath: "storedAlerts")
        let uidRef = alertRef.child(userID!)
        
        uidRef.observeSingleEvent(of: .value, with: {(snapshot) in
            for value in snapshot.children {
                let key = (value as AnyObject).key as String
                print(key)
                
                // Function call to add boundaries
                self.obtainAlertsFromFirebase(key: key)
                
            }
        })
        
    }
    
    func obtainAlertsFromFirebase(key: String){
        // create firebase reference
        let userID = Auth.auth().currentUser?.uid
        let alertRef = Database.database().reference(withPath: "storedAlerts")
        let uidRef = alertRef.child(userID!)
        let lowerAlertRef = uidRef.child(key)
        
        // Get values from firebase snapshot
       
        lowerAlertRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let alertString      = value?["alertText"]      as? String ?? ""
      
            
            print("from addBoundaries method", alertString)

        })

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Obtain data from firebase
        self.obtainKeys()
    }
    
    override func viewDidLoad() {
        
        // Set background gradient
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
    }
}
