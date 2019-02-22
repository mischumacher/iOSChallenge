//
//  EventsDetailViewController.swift
//  FargoEventsApp
//
//  Created by Mitch on 1/22/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import EVReflection
import SDWebImage
import KeychainAccess

class EventsDetailViewController: UITableViewController{
    
    var eventID = NSNumber()
    let tokenKeychain = Keychain(service: "com.schumacher.FargoEventsApp")
    
    var listDetails: [EventDetails] = [EventDetails]()
    var speakerDetails: [Speakers] = [Speakers]()
    var speaker2Details: [Speakers] = [Speakers]()
    var speakerID: [SpeakerIDS] = [SpeakerIDS]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    static func createEventDetails(eventID: NSNumber) -> EventsDetailViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventsDetailViewController") as! EventsDetailViewController
        vc.eventID = eventID
        vc.getEventDetails()
        vc.getSpeakerDetails()
        return vc
    }
    
    func getEventDetails(){
        
        let eventURL = String("https://challenge.myriadapps.com/api/v1/events/\(String(describing: eventID))")
        let userToken = tokenKeychain["loginToken"]
        let header: HTTPHeaders = ["Authorization": userToken!]
        
        Alamofire.request(eventURL, method: .get, headers: header)
            .responseArray { (response: DataResponse<[EventDetails]>) in
                if let result = response.value {
                    self.listDetails = result
                    for newList in result{
                        self.speakerID.append(contentsOf: newList.speakers)
                        if self.speakerID.count > 1{
                            self.getSecondSpeakerDetails(speakerID: self.speakerID[1].id!)
                        }
                    }
                    self.tableView.reloadData()
                }
        }
    }
    
    func getSpeakerDetails(){
        
        let speakerURL = String("https://challenge.myriadapps.com/api/v1/speakers/\(String(describing: eventID))")
        let userToken = tokenKeychain["loginToken"]
        let header: HTTPHeaders = ["Authorization": userToken!]
        
        Alamofire.request(speakerURL, method: .get, headers: header)
            .responseArray { (response: DataResponse<[Speakers]>) in
                if let result = response.value {
                    self.speakerDetails = result
                }
                self.tableView.reloadData()
                
        }
    }
    
    
    func getSecondSpeakerDetails(speakerID: NSNumber){
        let speakerURL = String("https://challenge.myriadapps.com/api/v1/speakers/\(String(describing: speakerID))")
        let userToken = tokenKeychain["loginToken"]
        let header: HTTPHeaders = ["Authorization": userToken!]
        Alamofire.request(speakerURL, method: .get, headers: header)
            .responseArray { (response: DataResponse<[Speakers]>) in
                if let result = response.value {
                    self.speaker2Details = result
                    
                }
                self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.speakerID.count > 1{
            return 1 + speakerID.count
        }else{
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return listDetails.count
        case 1:
            return speakerDetails.count
        case 2:
            return speaker2Details.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Speaker"
        case 2:
            return "Speaker"
        default:
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cellIdentifier = "Events Detail Cell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! EventDetailTableViewCell
            let dateFormatter = DateFormatter()
            let event = listDetails[indexPath.row]
            var formattedStartDate = ""
            var formattedEndDate = ""
            
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let startDate = event.start_date_time{
                let eventTime = dateFormatter.date(from: startDate)
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
                formattedStartDate = eventTime != nil ? dateFormatter.string(from: eventTime!) : "No Start Time"
            }
            if let endDate = event.end_date_time{
                dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                let eventTimed = dateFormatter.date(from: endDate)
                dateFormatter.dateFormat = "h:mm a"
                formattedEndDate = eventTimed != nil ? dateFormatter.string(from: eventTimed!) : "No End Time"
            }
            
            cell.eventTitle.text = event.title
            cell.eventDescription.text = event.event_description
            cell.locationLabel.text = event.location
            cell.eventDetailImage.sd_setImage(with: URL(string: event.image_url!), completed: nil)
            cell.eventDateAndTime.text = formattedStartDate + "-" + formattedEndDate
            return cell
            
        }else if indexPath.section == 1{
            
            
            let cellIdentifier2 = "SpeakerCell"
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2, for: indexPath as IndexPath) as! EventDetailTableViewCell
            
            let speaker = speakerDetails[indexPath.row]
            cell2.speakerImage.sd_setImage(with: URL(string: speaker.image_url!), completed: nil)
            cell2.speakerFirstName.text = speaker.first_name
            cell2.speakerLastName.text = speaker.last_name
            cell2.speakerBio.text = speaker.bio
            return cell2
            
        }else{
            let cellIdentifier3 = "Speaker2Cell"
            
            let cell3 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier3, for: indexPath as IndexPath) as! EventDetailTableViewCell
            
            let speaker = speaker2Details[indexPath.row]
            cell3.speaker2Img.sd_setImage(with: URL(string: speaker.image_url!), completed: nil)
            cell3.speaker2FirstName.text = speaker.first_name
            cell3.speaker2LastName.text = speaker.last_name
            cell3.speaker2Bio.text = speaker.bio
            return cell3
        }
        
        
        
        
    }
    
}






