//
//  DetailedStoredAlertsViewController.swift
//  
//
//  Created by Joshua Knight on 09/04/2020.
//

import Foundation
import UIKit

class DetailedStoredAlertsViewController: UIViewController {
    
    var completeStringArray = [String]()
    
    @IBOutlet weak var alertTextView: UITextView!
    
    @IBOutlet weak var sendAlertButton: UIButton!
    
    func sendNotifications(message: String){
        let url = URL(string: "https://api.notifymyecho.com/v1/NotifyMe?notification=\(message))&accessCode=amzn1.ask.account.AFYWLPJBB37FH5BSRVPBQCYDJLWH6KDO2GEC22AOUX5AF7INTD2OKVNVWW2DWJ6FEPWVAPJQDT5QUQFF3J64LV5TE66EIH7LMON6F5U6DGGEUDD6NHXRWZDLIRIPO3QM3ROFPJ662LEURCVA5XO7EBWYUZNYF7XSBLHXGZB6JBE3UVPMRNMSTK55XKCY74GKDBHTEZEA64TENUY")!
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard data != nil else {
                return
            }
        })
        
        task.resume()
    }
    
    @IBAction func sendAlertButton(_ sender: Any) {
        performSegue(withIdentifier: "detailedAlertConfirmation", sender: self)
        
        let message = alertTextView.text!
        
        let receivedText = alertTextView.text!
        
        let stringArray = receivedText.components(separatedBy: " ")
        
        for string in stringArray {
            let string = string + "%20"
            completeStringArray.append(string)
        }
        
        let joinedString = completeStringArray.joined()
        
        print(joinedString)
        
        sendNotifications(message: joinedString)
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
