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


class HomeViewController: UIViewController {
    
    // Database reference
    let ref = Database.database().reference(withPath: "userRef")
    
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var DateLabelTwo: UILabel!
    @IBOutlet weak var DateLabelOne: UILabel!
    @IBOutlet weak var GPSButton: UIButton!
    @IBOutlet weak var GPSHistoryButton: UIButton!
    @IBOutlet weak var BoundaryButton: UIButton!
    @IBOutlet weak var AnnouncementsButton: UIButton!
    @IBOutlet weak var AlertsButton: UIButton!
    @IBOutlet weak var RemindersButton: UIButton!
    
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
        DateLabelTwo.text = ",  \(Calendar.current.shortMonthSymbols[month-1]) \(date)"
    }
    
    
    override func viewDidLoad() {
        
        setUserRef()
        dateLabel()
        timeLabel()
        
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        GPSButton           .setHomeButtonStyles()
        GPSHistoryButton    .setHomeButtonStyles()
        BoundaryButton      .setHomeButtonStyles()
        AnnouncementsButton .setHomeButtonStyles()
        AlertsButton        .setHomeButtonStyles()
        RemindersButton     .setHomeButtonStyles()
    }
}

