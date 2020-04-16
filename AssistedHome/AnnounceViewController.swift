//
//  AnnounceViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 27/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AnnounceViewController: UIViewController {
    var completeStringArray = [String]()
    
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var announceTextView: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    @IBAction func sendButton(_ sender: Any) {
        
        let receivedText = announceTextView.text
        
        let stringArray = receivedText?.components(separatedBy: " ")
        
        for string in stringArray! {
            let string = string + "%20"
            completeStringArray.append(string)
        }
        
        let joinedString = completeStringArray.joined()
        
        print(joinedString)

        // Send Notification
        sendNotifications(message: joinedString)
        
        completeStringArray.removeAll()
        
        performSegue(withIdentifier: "sendAnnouncement", sender: self)
        
        
    }
    
    @IBAction func storeButton(_ sender: Any) {
        
        let userID = Auth.auth().currentUser?.uid
        
        let alert = announceTextView.text
        
        // post alert to firebase
        let alertRef = Database.database().reference(withPath: "storedAlerts")
        
        let userAlerts = alertRef.child(userID!)
        
        let alertToPost = userAlerts.childByAutoId()
        alertToPost.child("alertText") .setValue(alert!)
        
        performSegue(withIdentifier: "sendAnnouncement", sender: self)
        
        
    }
    
    @IBAction func clearButton(_ sender: Any) {
        announceTextView.text = ""
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
            performSegue(withIdentifier: "AnnounceViewToHome", sender: self)
        }
    }
    
    // Function for sending notificatons via POST
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Send test notification
        //sendNotifications()
        
        addSwipes()
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        textView.roundCornerView(cornerRadius: 8.0)
        
        announceTextView.font      = UIFont(name: "Arial", size: 20)
        announceTextView.textColor = UIColor.white
        
        // Apply button styling
        clearButton.setButtonStyles()
        sendButton.setButtonStyles()
        storeButton.setButtonStyles()
        
        // Reset font sizing
        clearButton.titleLabel?.font   = UIFont.boldSystemFont(ofSize: 15.0)
        sendButton.titleLabel?.font    = UIFont.boldSystemFont(ofSize: 15.0)
        storeButton.titleLabel?.font   = UIFont.boldSystemFont(ofSize: 15.0)
        
        
    }
    
  }
