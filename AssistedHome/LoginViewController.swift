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
    
    @IBAction func loginButton(_ sender: Any) {
        
        // Check confirm password field matches password field
        
        if loginPasswordField.text! == loginConfirmPasswordField.text!{
             // Firebase sign in with email
            Auth.auth().signIn(withEmail: loginEmailField.text!, password: loginPasswordField.text!) { (user, error) in
                if error == nil{
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "Password and Confirm Password fields do not match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }

    }
    
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
