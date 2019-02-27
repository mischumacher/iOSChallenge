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
}

class LoginPresenter{
    //context
    weak var view: LoginView?
    let tokenKeychain = Keychain(service: "com.schumacher.FargoEventsApp")
    var navController: UINavigationController?
    
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        //validates text field
        vc.validationLabel?.isHidden = true
        guard username != nil, username?.count != 0 else{
            vc.validationLabel?.text = "Please Enter Username"
            vc.validationLabel?.isHidden = false
            return
        }
        guard password != nil, password?.count != 0 else{
            vc.validationLabel?.text = "Please Enter Password"
            vc.validationLabel?.isHidden = false
            return
        }
        view?.showProgress()
        //makes api post request to login page and saves the user token to a user default
        let loginURL = "https://challenge.myriadapps.com/api/v1/login"
        let params = ["Username": username,"Password": password]
        Alamofire.request(loginURL, method: .post, parameters: params as Parameters)
            .responseArray { (response: DataResponse<[User]>) in
                if let result = response.value {
                    for newUser in result{
                        if newUser.token != nil{
                            self.tokenKeychain["loginToken"] = newUser.token
                            self.start()
                            self.view?.hideProgress()
                        }
                    }
                }
        }
    }
    
    
    
    func loadEvents(usertoken : String?){
        
        let eventsURL = "https://challenge.myriadapps.com/api/v1/events"
        let header: HTTPHeaders = ["Authorization": usertoken!]
        
        Alamofire.request(eventsURL, method: .get, headers: header)
            .responseArray { (response: DataResponse<[Events]>) in
                if let result = response.value {
                    self.navController = UINavigationController(rootViewController: EventsViewController.create(events: result))
                    self.navController!.navigationBar.barTintColor = UIColor.init(displayP3Red: 3/255, green: 68/255, blue: 106/255, alpha: 1)
                    self.view?.showLandingScreen()
                }
                
        }
    }
    
    func getEvents()-> UINavigationController{
        return navController!
    }
    
    func validateLogin(){
        view?.showProgress()
        let validateToken = tokenKeychain["loginToken"]
        if validateToken != nil{
            loadEvents(usertoken: validateToken)
            view?.hideProgress()
        }
        
    }
}


