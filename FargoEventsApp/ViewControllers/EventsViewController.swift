//
//  EventsViewController.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 11/12/18.
//  Copyright © 2018 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import EVReflection
import SDWebImage
import KeychainAccess




class EventsViewController: BaseTableViewController {
    
    //Mark: Properties
    @IBOutlet var selectedEvent: UITableView!
    
    var listOfEvents: [Events] = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        selectedEvent.delegate = self
        selectedEvent.dataSource = self
        self.selectedEvent.estimatedRowHeight = 85
        self.selectedEvent.rowHeight = UITableView.automaticDimension
        
    }
    
    static func create(events: [Events]) -> EventsViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
        vc.listOfEvents = events
        return vc
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        tokenKeychain["loginToken"] = nil
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   listOfEvents.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventsListCell"
        let cell = selectedEvent.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! EventsTableViewCell
        let events = listOfEvents[indexPath.row]
        cell.setupCell(event: events)
        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let event = listOfEvents[indexPath.row]
        self.navigationController?.pushViewController(EventsDetailViewController.createEventDetails(eventID:  event.id), animated: true)
    }
    
}




