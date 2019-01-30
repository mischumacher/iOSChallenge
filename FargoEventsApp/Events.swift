//
//  Events.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 12/1/18.
//  Copyright © 2018 Mitch Schumacher. All rights reserved.
//

import Foundation
import EVReflection

class Events: EVNetworkingObject {
    var id: NSNumber!
    var title: String? 
    var image_url: String?
    var start_date_time: String?
    var end_date_time: String?
    var location: String?
    var featured: String?
}


class Speakers: EVNetworkingObject{
    var id: NSNumber?
    var first_name: String?
    var last_name: String?
    var bio: String?
    var image_url: String?
}

class EventDetails: EVNetworkingObject {
    var id: NSNumber?
    var title: String?
    var image_url: String?
    var start_date_time: String?
    var end_date_time: String?
    var location: String?
    var featured: String?
    var event_description: String?
    
}






