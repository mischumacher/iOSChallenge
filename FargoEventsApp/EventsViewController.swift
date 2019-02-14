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


var myIndex: NSNumber?

class EventsViewController: UITableViewController {
    
    //Mark: Properties
    @IBOutlet var selectedEvent: UITableView!
    @IBAction func logoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginVC, animated: true, completion: nil)
    }
    
    var listOfEvents: [Events] = [Events]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedEvent.delegate = self
        selectedEvent.dataSource = self
        self.selectedEvent.estimatedRowHeight = 85
        self.selectedEvent.rowHeight = UITableView.automaticDimension
        let userTok = UserDefaults.standard.string(forKey: "isLoggedIn")
        print(userTok as Any)
        getList()

}
    
    func getList(){
        
        let urlIndex = "https://challenge.myriadapps.com/api/v1/events"
        let userTok = UserDefaults.standard.string(forKey: "isLoggedIn")
        let header: HTTPHeaders = ["Authorization": userTok!]
        
        Alamofire.request(urlIndex, method: .get, headers: header)
            .responseArray { (response: DataResponse<[Events]>) in
               if let result = response.value {
                for newList in result{
                    self.listOfEvents.append(newList)
                }
                self.selectedEvent.reloadData()
                }
    
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   listOfEvents.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        let cellIdentifier = "EventsListCell"
        
        let cell = selectedEvent.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! EventsTableViewCell
        
        let event = listOfEvents[indexPath.row]
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: event.start_date_time!)
        cell.eventsName.text = event.title
        cell.photoImageView.sd_setImage(with: URL(string: event.image_url!), completed: nil)
        cell.startDateTime.text = dateFormatter.string(from: date!)
        return cell
        
    }
    
     // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myIndex = listOfEvents[indexPath.row].id!
        performSegue(withIdentifier: "segue", sender: self)
    }

}
