//
//  LoginViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 24/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var FooterView: UIView!
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "showLoginToSignUp", sender: self)
    }
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        FooterView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
    }
    
    
}
