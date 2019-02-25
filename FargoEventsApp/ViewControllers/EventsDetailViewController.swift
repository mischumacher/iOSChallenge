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
            let event = listDetails[indexPath.row]
            cell.setUpEventCell(eventDetails: event)
            return cell
            
        }else if indexPath.section == 1{
            
            let cellIdentifier2 = "SpeakerCell"
            let speakerCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2, for: indexPath as IndexPath) as! EventDetailTableViewCell
            let speaker = speakerDetails[indexPath.row]
            speakerCell.setSpeakerCell(speaker: speaker)
            return speakerCell
            
        }else{
            
            let cellIdentifier3 = "SpeakerCell"
            let secondSpeakerCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier3, for: indexPath as IndexPath) as! EventDetailTableViewCell
            let speaker = speaker2Details[indexPath.row]
            secondSpeakerCell.setSpeakerCell(speaker: speaker)
            return secondSpeakerCell
        }
    }
    
}






