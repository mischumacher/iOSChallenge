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

class EventsDetailViewController: UITableViewController{
    
    var cellIndex = NSNumber()
    
    var listDetails: [EventDetails] = [EventDetails]()
    var speakerDetails: [Speakers] = [Speakers]()
    var speaker2Details: [Speakers] = [Speakers]()
    var speakerID: [SpeakerIDS] = [SpeakerIDS]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getEventDetails()
        getSpeakerDetails()
        
    }
    
    func getEventDetails(){
        
        let eventURL = String("https://challenge.myriadapps.com/api/v1/events/\(String(describing: cellIndex))")
        let userTok = UserDefaults.standard.string(forKey: "isLoggedIn")
        let header: HTTPHeaders = ["Authorization": userTok!]
        
        Alamofire.request(eventURL, method: .get, headers: header)
            .responseArray { (response: DataResponse<[EventDetails]>) in
                if let result = response.value {
                    for newList in result{
                        self.listDetails.append(newList)
                        self.speakerID.append(contentsOf: newList.speakers)
                        if self.speakerID.count > 1{
                            let speakerURL = String("https://challenge.myriadapps.com/api/v1/speakers/\(String(describing: newList.speakers[1].id!))")
                            Alamofire.request(speakerURL, method: .get, headers: header)
                                .responseArray { (response: DataResponse<[Speakers]>) in
                                    if let result = response.value {
                                        for newSpeaker in result{
                                            self.speaker2Details.append(newSpeaker)
                                        }
                                    }
                                    self.tableView.reloadData()
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
        }
    }
    
    func getSpeakerDetails(){
        
        let speakerURL = String("https://challenge.myriadapps.com/api/v1/speakers/\(String(describing: cellIndex))")
        let userTok = UserDefaults.standard.string(forKey: "isLoggedIn")
        let header: HTTPHeaders = ["Authorization": userTok!]
        
        Alamofire.request(speakerURL, method: .get, headers: header)
            .responseArray { (response: DataResponse<[Speakers]>) in
                if let result = response.value {
                    for newList in result{
                        self.speakerDetails.append(newList)
                    }
                    self.tableView.reloadData()
                }
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
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let startDate = dateFormatter.date(from: event.start_date_time!)
            let endDate = dateFormatter.date(from: event.end_date_time!)
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
            let formattedStartDate = dateFormatter.string(from: startDate!)
            dateFormatter.dateFormat = "h:mm a"
            let formattedEndDate = dateFormatter.string(from: endDate!)
            
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





