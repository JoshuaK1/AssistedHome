//
//  HomeViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 24/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var GPSButton: UIButton!
    @IBOutlet weak var GPSHistoryButton: UIButton!
    @IBOutlet weak var BoundaryButton: UIButton!
    @IBOutlet weak var AnnouncementsButton: UIButton!
    @IBOutlet weak var AlertsButton: UIButton!
    @IBOutlet weak var RemindersButton: UIButton!
    
    @IBAction func announceButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToAnnounce", sender: self)
    }
    
    
    override func viewDidLoad() {
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

