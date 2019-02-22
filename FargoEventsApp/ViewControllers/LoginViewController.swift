//
//  LoginViewController.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 11/26/18.
//  Copyright © 2018 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import EVReflection
import KeychainAccess

class LoginViewController: UIViewController{
    
    //Mark:Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var validationLabel: UILabel!
    
    let tokenKeychain = Keychain(service: "com.schumacher.FargoEventsApp")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard UserDefaults.standard.isFirstLaunch() == true else{
            UserDefaults.standard.setLaunchStatus()
            tokenKeychain["loginToken"] = nil
            return
        }
        
        
        for textField in [usernameTextField, passwordTextField]{
            textField!.delegate = self
        }
        
        
        
        let validateToken = tokenKeychain["loginToken"]
        if validateToken != nil{
            getEvents(usertoken: validateToken)
        }
        
    }
    
    //Mark: TextFields
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder()
            LogIn(username: usernameTextField.text, password: usernameTextField.text)
        }
        return true
    }
    
    //Mark: Login Button
    
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        LogIn(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    func LogIn(username: String?, password: String?){
        //validates text field
        validationLabel.isHidden = true
        
        guard username != nil, username?.count != 0 else{
            validationLabel.isHidden = false
            validationLabel.text = "Please Enter Username"
            return
        }
        guard password != nil, password?.count != 0 else{
            validationLabel.isHidden = false
            validationLabel.text = "Please Enter Password"
            return
        }
        
        //makes api post request to login page and saves the user token to a user default
        let loginURL = "https://challenge.myriadapps.com/api/v1/login"
        let params = ["Username": username,"Password": password]
        Alamofire.request(loginURL, method: .post, parameters: params as Parameters)
            .responseArray { (response: DataResponse<[User]>) in
                if let result = response.value {
                    for newUser in result{
                        if newUser.token != nil{
                            self.tokenKeychain["loginToken"] = newUser.token
                            self.getEvents(usertoken: newUser.token)
                        }
                    }
                }
        }
    }
    
    func getEvents(usertoken : String?){
        
        let eventsURL = "https://challenge.myriadapps.com/api/v1/events"
        let header: HTTPHeaders = ["Authorization": usertoken!]
        
        Alamofire.request(eventsURL, method: .get, headers: header)
            .responseArray { (response: DataResponse<[Events]>) in
                if let result = response.value {
                    let navController = UINavigationController(rootViewController: EventsViewController.create(events: result))
                    navController.navigationBar.barTintColor = UIColor.init(displayP3Red: 3/255, green: 68/255, blue: 106/255, alpha: 1)
                    self.present(navController, animated: true, completion: nil)
                }
                else{
                    self.validationLabel.isHidden = false
                    self.validationLabel.text = "Request failed no connection"
                }
                
        }
        
    }
    
}


extension LoginViewController : UITextFieldDelegate{
    
}

