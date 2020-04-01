//
//  EventDataStruct.swift
//  AssistedHome
//
//  Created by Joshua Knight on 31/03/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import EventKit


struct Events {
    
    static var locationStrings = [String]()
    static var eventTitles = [String]()
    
    static var eventIndex = 0
    
    static var longtitude = CLLocationDegrees()
    static var latitude =  CLLocationDegrees()
    
    // Array of location objects
    static var coorindates = [CLLocationCoordinate2D]()
    
}
