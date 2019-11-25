//
//  LoginViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 24/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var FooterView: UIView!
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet weak var loginConfirmPasswordField: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "showLoginToSignUp", sender: self)
    }
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        FooterView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        // Function to underline text fields
        loginEmailField.underlined()
        loginPasswordField.underlined()
        loginConfirmPasswordField.underlined()
        
        loginPasswordField.isSecureTextEntry               = true
        loginConfirmPasswordField.isSecureTextEntry        = true
        loginPasswordField.attributedPlaceholder           = NSAttributedString(string: "Password",
                                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        loginConfirmPasswordField.attributedPlaceholder    = NSAttributedString(string: "Confirm Password",
                                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        loginEmailField.attributedPlaceholder              = NSAttributedString(string: "assistedhome@example.com",
                                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        loginButton.layer.cornerRadius = 7
    }
    
    
}
