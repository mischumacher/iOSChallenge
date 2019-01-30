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
    
    var listDetails: [EventDetails] = [EventDetails]()
    var speakerDetails: [Speakers] = [Speakers]()
    

        override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getEventDetails()
        getSpeakerDetails()
        
    }
    

    
    func getEventDetails(){
        
        let urlIndex = String("https://challenge.myriadapps.com/api/v1/events/\(String(describing: myIndex!))")
        
        Alamofire.request(urlIndex,
                          method: .get,
                          headers: ["Authorization": "supersecrettoken"])
            .responseArray { (response: DataResponse<[EventDetails]>) in
                if let result = response.value {
                    for newList in result{
                        self.listDetails.append(newList)
                    }
                    self.tableView.reloadData()
                }
                
        }
    }
    
    func getSpeakerDetails(){
        
        let urlIndex = String("https://challenge.myriadapps.com/api/v1/speakers/\(String(describing: myIndex!))")
        
        Alamofire.request(urlIndex,
                          method: .get,
                          headers: ["Authorization": "supersecrettoken"])
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   listDetails.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cellIdentifier = "Events Detail Cell"
            
             let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! EventDetailTableViewCell
            
            let event = listDetails[indexPath.row]
            cell.eventTitle.text = event.title
            cell.eventDescription.text = event.event_description
            cell.locationLabel.text = event.location
            cell.eventDetailImage.sd_setImage(with: URL(string: event.image_url!), completed: nil)
             return cell
            
        }else{
            let cellIdentifier2 = "SpeakerCell"
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2, for: indexPath as IndexPath) as! EventDetailTableViewCell
            
            
            let speaker = speakerDetails[indexPath.row]
            cell2.speakerImage.sd_setImage(with: URL(string: speaker.image_url!), completed: nil)
            cell2.speakerFirstName.text = speaker.first_name
            cell2.speakerLastName.text = speaker.last_name
            cell2.speakerBio.text = speaker.bio
            return cell2
        }
        
        
    }
    
}


    


