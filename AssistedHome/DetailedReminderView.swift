//
//  DetailedReminderView.swift
//  AssistedHome
//
//  Created by Joshua Knight on 31/03/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit

class DetailedReminderView: UIViewController {
    
    
    @IBOutlet weak var IndexLabel: UILabel!
    
    override func viewDidLoad() {
        IndexLabel.text = "Value passed through is \(Events.eventIndex) "
    }
    
    
    
    
}
