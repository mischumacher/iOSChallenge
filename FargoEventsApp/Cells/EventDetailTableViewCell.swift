//
//  EventDetailTableViewCell.swift
//  FargoEventsApp
//
//  Created by Mitch on 1/22/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit

class EventDetailTableViewCell: UITableViewCell{
    
    @IBOutlet weak var eventDetailImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventDateAndTime: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var speakerFirstName: UILabel!
    @IBOutlet weak var speakerLastName: UILabel!
    @IBOutlet weak var speakersLabel: UILabel!
    @IBOutlet weak var speakerBio: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var speaker2Img: UIImageView!
    @IBOutlet weak var speaker2FirstName: UILabel!
    @IBOutlet weak var speaker2LastName: UILabel!
    @IBOutlet weak var speaker2Bio: UILabel!
    
    func setUpEventCell(eventDetails: EventDetails){
        let dateFormatter = DateFormatter()
        var formattedStartDate = ""
        var formattedEndDate = ""
        
        dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let startDate = eventDetails.start_date_time{
            let eventTime = dateFormatter.date(from: startDate)
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
            formattedStartDate = eventTime != nil ? dateFormatter.string(from: eventTime!) : "No Start Time"
        }
        if let endDate = eventDetails.end_date_time{
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let eventTimed = dateFormatter.date(from: endDate)
            dateFormatter.dateFormat = "h:mm a"
            formattedEndDate = eventTimed != nil ? dateFormatter.string(from: eventTimed!) : "No End Time"
        }
        
        eventTitle.text = eventDetails.title
        eventDescription.text = eventDetails.event_description
        locationLabel.text = eventDetails.location
        eventDetailImage.sd_setImage(with: URL(string: eventDetails.image_url!), completed: nil)
        eventDateAndTime.text = formattedStartDate + "-" + formattedEndDate
    }
    
    func setSpeakerCell(speaker: Speakers){
        
        speakerImage.sd_setImage(with: URL(string: speaker.image_url!), completed: nil)
        speakerFirstName.text = speaker.first_name
        speakerLastName.text = speaker.last_name
        speakerBio.text = speaker.bio
    }
    
}
