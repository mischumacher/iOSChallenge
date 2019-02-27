//
//  LoginPresenter.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/25/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess
import Alamofire
import EVReflection

protocol LoginView: BaseView{
    func showLandingScreen()
    func DisplayValidationMessage()
    func NetworkAlertMessage()
}

class LoginPresenter{
    //context
    weak var view: LoginView?
    let tokenKeychain = Keychain(service: "com.schumacher.FargoEventsApp")
    var storedEvents: [Events] = [Events]()
    
    //Intialization
    init(with view: LoginView) {
        self.view = view
    }
    
    func start() {
        guard UserDefaults.standard.isFirstLaunch() == true else{
            UserDefaults.standard.setLaunchStatus()
            tokenKeychain["loginToken"] = nil
            return
        }
        validateLogin()
    }
    
    func login(_ username: String?, _ password: String?) {
        //validates text field
        guard username != nil, username?.count != 0 else{
            view?.DisplayValidationMessage()
            return
        }
        guard password != nil, password?.count != 0 else{
            view?.DisplayValidationMessage()
            return
        }
        view?.showProgress()
        //makes api post request to login page and saves the user token to a user default
        let loginURL = "https://challenge.myriadapps.com/api/v1/login"
        let params = ["Username": username,"Password": password]
        Alamofire.request(loginURL, method: .post, parameters: params as Parameters)
            .responseArray { [weak self] (response: DataResponse<[User]>) in
                if let result = response.value {
                    for newUser in result{
                        if newUser.token != nil{
                            self?.tokenKeychain["loginToken"] = newUser.token
                            self?.validateLogin()
                            self?.view?.hideProgress()
                        }
                    }
                }else{
                    self?.view?.NetworkAlertMessage()
                    self?.view?.hideProgress()
                }
        }
    }
    
    func handleResponse(_ response: DataResponse<Any>) -> Void
    {
        
    }
    
    func loadEvents(usertoken : String?){
        
        let eventsURL = "https://challenge.myriadapps.com/api/v1/events"
        let header: HTTPHeaders = ["Authorization": usertoken!]
        view?.showProgress()
        Alamofire.request(eventsURL, method: .get, headers: header)
            .responseArray { [weak self] (response: DataResponse<[Events]>) in
                if let result = response.value {
                    self?.storedEvents = result
                    self?.view?.hideProgress()
                    self?.view?.showLandingScreen()
                }else{
                    self?.view?.NetworkAlertMessage()
                    self?.view?.hideProgress()
                }
                
        }
    }
    
    func getEvents()-> [Events]{
        return storedEvents
    }
    
    func validateLogin(){
        let validateToken = tokenKeychain["loginToken"]
        if validateToken != nil{
            loadEvents(usertoken: validateToken)
        }
        
    }
}


