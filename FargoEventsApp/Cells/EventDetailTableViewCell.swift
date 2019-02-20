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
    
}
