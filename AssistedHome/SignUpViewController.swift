//
//  SignUpViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 24/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    @IBAction func SignUpButton(_ sender: Any) {
        performSegue(withIdentifier: "showSigninViewControllerFromSignup", sender: self)
        
    }
    @IBOutlet weak var FooterView: UIView!
    @IBOutlet weak var SignUpEmailField: UITextField!
    @IBOutlet weak var SignUpPasswordField: UITextField!
    @IBOutlet weak var SignUpConfirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background gradient and footer
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        FooterView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        // Call extension to set text field style
        SignUpEmailField.underlined()
        SignUpPasswordField.underlined()
        SignUpConfirmPasswordField.underlined()
        
        SignUpPasswordField.isSecureTextEntry               = true
        SignUpConfirmPasswordField.isSecureTextEntry        = true
        SignUpPasswordField.attributedPlaceholder           = NSAttributedString(string: "Password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        SignUpConfirmPasswordField.attributedPlaceholder    = NSAttributedString(string: "Confirm Password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        SignUpEmailField.attributedPlaceholder              = NSAttributedString(string: "assistedhome@example.com",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
   
        
        
        
        

        
    }
    
    
}

