//
//  PopupViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 04/04/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import BEMCheckBox

class PopupViewController: UIViewController {
    
    @IBOutlet weak var checkbox: BEMCheckBox!
    @IBOutlet weak var popupView: UIView!
    
    func animateSafeCheckMark(){
        // Wait 1 second before animating check mark
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkbox.setOn(true, animated: true)
            self.dismissView(dismiss: true)
        }
    }
    
    func dismissView(dismiss: Bool) -> Void {
        if dismiss {
            // Wait 1 second before dismissing the view
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        popupView.layer.cornerRadius = 10.0
        self.checkbox.on = false
        
        // Call fucntion to animate check mark
        animateSafeCheckMark()
        
        
    }
    
}
