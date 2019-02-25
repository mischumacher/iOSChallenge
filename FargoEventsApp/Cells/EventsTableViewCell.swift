//
//  EventsTableViewCell.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 11/28/18.
//  Copyright © 2018 Mitch Schumacher. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    //Mark: Properties
    @IBOutlet weak var eventsName: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var startDateTime: UILabel!
    
    func setupCell(event: Events?){
        
        let dateFormatter = DateFormatter()
        var formattedStartDate = ""
        var formattedEndDate = ""
    
    if event != nil{
        dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let startDate = event!.start_date_time{
            let eventTime = dateFormatter.date(from: startDate)
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
            formattedStartDate = eventTime != nil ? dateFormatter.string(from: eventTime!) : "No Start Time"
        }
        if let endDate = event!.end_date_time{
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let eventTime = dateFormatter.date(from: endDate)
            dateFormatter.dateFormat = "h:mm a"
            formattedEndDate = eventTime != nil ? dateFormatter.string(from: eventTime!) : "No End Time"
        }
        
    }
    
        eventsName.text = event?.title != nil ? event!.title : "Title Not Found"
        photoImageView.sd_setImage(with: URL(string: event!.image_url!), completed: nil)
        startDateTime.text = formattedStartDate + "-" + formattedEndDate
    }

}
