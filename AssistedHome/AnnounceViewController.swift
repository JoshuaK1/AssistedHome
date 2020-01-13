//
//  AnnounceViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 27/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit

class AnnounceViewController: UIViewController {
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var announceTextView: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendButton(_ sender: Any) {
        announceTextView.text = ""
    }
    
    
    @IBAction func clearButton(_ sender: Any) {
        announceTextView.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        textView.roundCornerView(cornerRadius: 8.0)
        
        announceTextView.font      = UIFont(name: "Arial", size: 20)
        announceTextView.textColor = UIColor.white
        
        clearButton.setButtonStyles()
        sendButton.setButtonStyles()
        
    }
    
    
}
