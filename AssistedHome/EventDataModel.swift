//
//  EventDataModel.swift
//  AssistedHome
//
//  Created by Joshua Knight on 31/03/2020.
//  Copyright © 2020 Joshua Knight. All rights reserved.
//

import Foundation
import UIKit


class EventData: NSObject {
    
    var location: String?
    
    init(location: String){
        self.location = location
    }
}



//
//class Videos:NSObject{
//
//    var title:String?
//    var thumbNailImageView : String?
//    var channel : String?
//    var numberOfView : Int?
//    var duration : Int?
//
//    init(title:String,thumbNailImageView:String,numberOfView:Int,duration:Int,channel:String) {
//        self.channel = channel
//        self.title = title
//        self.thumbNailImageView = thumbNailImageView
//        self.duration = duration
//        self.numberOfView = numberOfView
//
//    }
//}
