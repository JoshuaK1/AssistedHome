//
//  PinAnnotation.swift
//  
//
//  Created by Joshua Knight on 02/12/2019.
//

import Foundation
import MapKit
import UIKit

class PinAnnotation: NSObject, MKAnnotation {
    
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var _title: String = String("")
    private var _subtitle: String = String("")
    
    var coordinate: CLLocationCoordinate2D{
        get {
            return coord
        }
    }
    
    
    func setCoordinate(newCoorindate: CLLocationCoordinate2D){
        self.coord = newCoorindate
    }
    
    var title: String? {
        get {
            return _title
        }
        set (value) {
            self._title = value!
        }
    }
    
    var subtitle: String? {
        get {
            return _subtitle
        }
        set (value){
            self._subtitle = value!
        }
    }
}
