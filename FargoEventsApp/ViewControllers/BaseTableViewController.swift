//
//  BaseTableViewController.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/27/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

protocol BaseTableView: class {
    
    func showProgress()
    func hideProgress()
    func removeUserToken()
    func getUserToken() -> String?
}

class BaseTableViewController: UITableViewController, BaseTableView{
     let tokenKeychain = Keychain(service: "com.schumacher.FargoEventsApp")
    
    func showProgress(){
        ProgressSpinner.startSpinner(uiView: view)
    }
    func hideProgress() {
        ProgressSpinner.stopSpinner(uiView: view)
    }
    func removeUserToken() {
        tokenKeychain["loginToken"] = nil
    }
    func getUserToken() -> String? {
        return tokenKeychain["loginToken"]
    }
}
