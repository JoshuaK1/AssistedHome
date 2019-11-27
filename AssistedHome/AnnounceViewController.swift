//
//  AnnounceViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 27/11/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit

class AnnounceViewController: UIViewController {
    
    @IBOutlet weak var textView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        textView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        textView.roundCornerView(cornerRadius: 8.0)
        
    }
    
    
}
