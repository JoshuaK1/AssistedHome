//
//  SignUpViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 24/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var SignUpCreateButton: UIButton!
    @IBOutlet weak var FooterView: UIView!
    @IBOutlet weak var SignUpEmailField: UITextField!
    @IBOutlet weak var SignUpPasswordField: UITextField!
    @IBOutlet weak var SignUpConfirmPasswordField: UITextField!
    
    
    // This action needs to be changed from SignUp to SignIn
    @IBAction func SignUpButton(_ sender: Any) {
        performSegue(withIdentifier: "showSigninViewControllerFromSignup", sender: self)
        
    }
    
    // More validation to be added here
    @IBAction func SignUpCreateButton(_ sender: Any) {
        if SignUpPasswordField.text != SignUpConfirmPasswordField.text {
            let alertController = UIAlertController(title: "Passwords do not match", message: "Please re-type and try again", preferredStyle: .alert)
            let defaultAction   = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else if SignUpEmailField.text! == "" || SignUpPasswordField.text! == "" || SignUpConfirmPasswordField.text! == "" {
            // Present alert View Controller if fields contain no text
            let alertController = UIAlertController(title: "Sign up failed", message: "Email and password fields are incorrect", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if !(validateEmail(enteredEmail: SignUpEmailField.text!)) {
            // Present alert view controller if email is not valid
            let alertController = UIAlertController(title: "Sign up failed", message: "Email is not valid", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: SignUpEmailField.text!, password: SignUpPasswordField.text!){
                (user,error) in
                
                if error == nil{
                    self.performSegue(withIdentifier: "SignUpToHome", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Sign up failed", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction   = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    // Function to validate email address
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
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
        
        // Button Formatting
        SignUpCreateButton.backgroundColor    = UIColor.white.withAlphaComponent(0.5)
        SignUpCreateButton.layer.cornerRadius = 7
   
        
        
        
        

        
    }
    
    
}

