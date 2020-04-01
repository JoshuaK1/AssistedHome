//
//  RadioButtons.swift
//  AssistedHome
//
//  Created by Joshua Knight on 01/04/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit


class RadioButtons: UIButton {
    var alternateButton:Array<RadioButtons>?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons() {
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButtons in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                self.layer.borderColor = white.cgColor
            } else {
                let grey = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
                self.layer.borderColor = grey.cgColor
        }
    }
  }
}
