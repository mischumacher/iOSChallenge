//
//  BaseViewController.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/26/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess


protocol BaseView: class {
    
    func showProgress()
    func hideProgress()
    func setUserToken(userToken: String?)
    func removeUserToken()
    func getUserToken() -> String?
}

class BaseViewController: UIViewController, BaseView{

    let tokenKeychain = Keychain(service: "com.schumacher.FargoEventsApp")
    
    func showProgress(){
         ProgressSpinner.startSpinner(uiView: view)
    }
    func hideProgress() {
         ProgressSpinner.stopSpinner(uiView: view)
    }
    func setUserToken(userToken: String?) {
        tokenKeychain["loginToken"] = userToken
    }
    func removeUserToken() {
        tokenKeychain["loginToken"] = nil
    }
    func getUserToken() -> String? {
        return tokenKeychain["loginToken"]
    }
        
    
}
