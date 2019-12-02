//
//  CLPlacemark-extension.swift
//  AssistedHome
//
//  Created by Joshua Knight on 02/12/2019.
//  Copyright © 2019 Joshua Knight. All rights reserved.
//

import Foundation
import MapKit

extension CLPlacemark {
    
    
    func createAddressString() -> String {
        
        switch (self.subThoroughfare, self.thoroughfare, self.locality, self.administrativeArea, self.postalCode, self.country) {
        case let (.some(subThoroughfare), .some(thoroughfare), .some(locality), .some(administrativeArea), .some(_), .some(_)):
             return "\(subThoroughfare), \(thoroughfare), \(locality), \(administrativeArea)"
        default:
            return ""
        }
    }
}
