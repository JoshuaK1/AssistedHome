//
//  DetailedStoredAlertsViewController.swift
//  
//
//  Created by Joshua Knight on 09/04/2020.
//

import Foundation
import UIKit

class DetailedStoredAlertsViewController: UIViewController {
    
    @IBOutlet weak var alertTextView: UITextView!
    
    @IBOutlet weak var sendAlertButton: UIButton!
    
    @IBAction func sendAlertButton(_ sender: Any) {
        performSegue(withIdentifier: "detailedAlertConfirmation", sender: self)
    }
    
    //Add support for swipe gestures
    func addSwipes(){
        let directions:[UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
        
    }
    
    //Handle swipe gestures
    @objc func handleSwipes(sender: UISwipeGestureRecognizer){
        if sender.direction == .right{
            performSegue(withIdentifier: "detailedAlertToStoredAlerts", sender: self)
        }
    }
    
    func getStoredAlert(){
        
        // get index path from struct
        let index = StoredAlerts.alertIndex
        
        let alert = StoredAlerts.storedAlerts[index]
        
        alertTextView.text = alert
        
        print("Alert taken from struct", alert)
        
    }

    override func viewDidLoad() {
        
        addSwipes()
        
        getStoredAlert()
        
        // Set buttons styling
        sendAlertButton.setButtonStyles()
        
        alertTextView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        alertTextView.roundCornerView(cornerRadius: 8.0)
        alertTextView.isEditable = false
        alertTextView.font = UIFont(name: "Arial", size: 20)
        alertTextView.textColor = UIColor.white
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
    }
}
