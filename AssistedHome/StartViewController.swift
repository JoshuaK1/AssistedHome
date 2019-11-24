//
//  StartViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 24/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
    
    @IBOutlet weak var FooterView: UIView!
    @IBAction func SignUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showSignupViewController", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        FooterView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
}
