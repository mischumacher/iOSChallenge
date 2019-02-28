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

class EventsDetailViewController: BaseTableViewController{
    
    var eventID = NSNumber()
    var presenter: EventDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    static func createEventDetails(eventID: NSNumber) -> EventsDetailViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventsDetailViewController") as! EventsDetailViewController
          vc.eventID = eventID
          vc.presenter = EventDetailsPresenter(with: vc)
          vc.presenter.start()
        return vc
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if presenter.getSpeakerID().count > 1{
            return 1 + presenter.getSpeakerID().count
        }else{
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return presenter.getListDetails().count
        case 1:
            return presenter.getSpeakerDetails().count
        case 2:
            return presenter.getSpeaker2Details().count
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
           // presenter.loadEventDetails()
            let cellIdentifier = "Events Detail Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! EventDetailTableViewCell
            let event = presenter.getListDetails()[indexPath.row]
            cell.setUpEventCell(eventDetails: event)
            return cell
            
        }else if indexPath.section == 1{
           // presenter.loadSpeakerDetails()
            let cellIdentifier2 = "SpeakerCell"
            let speakerCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2, for: indexPath as IndexPath) as! EventDetailTableViewCell
            let speaker = presenter.getSpeakerDetails()[indexPath.row]
            speakerCell.setSpeakerCell(speaker: speaker)
            return speakerCell
            
        }else{
            
            let cellIdentifier3 = "SpeakerCell"
            let secondSpeakerCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier3, for: indexPath as IndexPath) as! EventDetailTableViewCell
            let speaker = presenter.getSpeaker2Details()[indexPath.row]
            secondSpeakerCell.setSpeakerCell(speaker: speaker)
            return secondSpeakerCell
        }
    }
    
}

extension EventsDetailViewController: EventDetailsView{
    func getEventID() -> NSNumber? {
        return eventID
    }
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    func networkAlertMessage() {
        let alert = UIAlertController(title: "Connection Failed", message: "Please Check Connection \n and try again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}






