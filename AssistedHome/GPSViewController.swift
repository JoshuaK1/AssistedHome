//
//  GPSViewController.swift
//  AssistedHome
//
//  Created by Joshua Knight on 13/01/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class GPSViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    

    //Add Support for swipe gestures
    func addSwipes(){
        let directions:[UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
        
    }
    
    //Handle swipe gestures
    @objc func handleSwipes(sender: UISwipeGestureRecognizer){
        if sender.direction == .right{
            performSegue(withIdentifier: "GPSViewToHomeView", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colours.lightBlue, colorTwo: Colours.purple)
        
        addSwipes()
    }
    


}
