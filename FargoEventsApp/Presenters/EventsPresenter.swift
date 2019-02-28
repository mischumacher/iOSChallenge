//
//  EventsPresenter.swift
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


protocol EventsView: BaseView{

}

class EventsPresenter{
    //context
    weak var view: EventsView?

    
    //Intialization
    init(with view: EventsView) {
        self.view = view
    }
    
    func start() {
    
    }
    
}

