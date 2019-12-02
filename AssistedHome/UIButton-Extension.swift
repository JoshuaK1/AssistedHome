//
//  UIButton-Extension.swift
//  AssistedHome
//
//  Created by Joshua Knight on 27/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setButtonStyles(){
        self.titleLabel?.font   = UIFont.boldSystemFont(ofSize: 30.0)
        self.backgroundColor    = UIColor.white.withAlphaComponent(0.5)
        self.layer.cornerRadius = 7
        self.setTitleColor(.white, for: .normal)
        
    }
    
    func setHomeButtonStyles(){
        self.backgroundColor    = UIColor.white.withAlphaComponent(0.5)
        self.layer.cornerRadius = 7
        self.setTitleColor(.white, for: .normal)
        
    }
}
