//
//  EventDetailsPresenter.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/27/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess
import Alamofire
import EVReflection


protocol EventDetailsView: BaseTableView{
    func getEventID() -> NSNumber?
    func reloadTable()
    func networkAlertMessage()
}

class EventDetailsPresenter{
    //context
    weak var view: EventDetailsView?

    var listDetails: [EventDetails] = [EventDetails]()
    var speakerDetails: [Speakers] = [Speakers]()
    var speaker2Details: [Speakers] = [Speakers]()
    var speakerID: [SpeakerIDS] = [SpeakerIDS]()
    
    //Intialization
    init(with view: EventDetailsView) {
        self.view = view
    }
    
    func start() {
        loadEventDetails()
        loadSpeakerDetails()
        
    }
    
    func loadEventDetails(){
        
        let eventURL = String("https://challenge.myriadapps.com/api/v1/events/\(String(describing: (view?.getEventID())!))")
        let header: HTTPHeaders = ["Authorization": (view?.getUserToken())!]
        
        Alamofire.request(eventURL, method: .get, headers: header)
            .responseArray { [weak self] (response: DataResponse<[EventDetails]>) in
                if let result = response.value {
                    self?.listDetails = result
                    for newList in result{
                        self?.speakerID.append(contentsOf: newList.speakers)
                        if self?.speakerID.count ?? 0 > 1{
                            self?.getSecondSpeakerDetails(speakerID: (self?.speakerID[1].id)!)
                        }
                    }
                }else{
                    self?.view?.networkAlertMessage()
                }
                  self?.view?.reloadTable()
        }
    }
    
    func loadSpeakerDetails(){
        
        let speakerURL = String("https://challenge.myriadapps.com/api/v1/speakers/\(String(describing: (view?.getEventID())!))")
        let header: HTTPHeaders = ["Authorization": (view?.getUserToken())!]
        
        Alamofire.request(speakerURL, method: .get, headers: header)
            .responseArray { [weak self] (response: DataResponse<[Speakers]>) in
                if let result = response.value {
                    self?.speakerDetails = result
                }else{
                    self?.view?.networkAlertMessage()
                }
                self?.view?.reloadTable()
        }
    }
    
    
    func getSecondSpeakerDetails(speakerID: NSNumber){
        let speakerURL = String("https://challenge.myriadapps.com/api/v1/speakers/\(String(describing: speakerID))")
        let header: HTTPHeaders = ["Authorization": (view?.getUserToken())!]
        Alamofire.request(speakerURL, method: .get, headers: header)
            .responseArray { [weak self] (response: DataResponse<[Speakers]>) in
                if let result = response.value {
                    self?.speaker2Details = result
                    
                }else{
                    self?.view?.networkAlertMessage()
                }
                self?.view?.reloadTable()
        }
    }
    
    func getListDetails() -> [EventDetails] {
        return listDetails
    }
    func getSpeakerDetails() -> [Speakers]{
        return speakerDetails
    }
    func getSpeaker2Details() -> [Speakers]{
        return speaker2Details
    }
    func getSpeakerID() -> [SpeakerIDS]{
        return speakerID
    }
    
}
