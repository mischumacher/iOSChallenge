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

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    //Mark:Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var validationLabel: UILabel!
    
    
    var storedUser: [User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        for textField in [usernameTextField, passwordTextField]{
            textField!.delegate = self
        }
        //checks to see if the user is already logged in
        let userTok = UserDefaults.standard.string(forKey: "isLoggedIn")
        if userTok != nil{
            performSegue(withIdentifier: "mainSegue", sender: self)
        }
        
    }
    
    //Mark: TextFields
    
    var errorMessage: String?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder() 
        }
        return true
    }
    
    //Mark: Login Button
    
    @IBAction func loginButtonDidTouch(_ sender: Any) {
       
        //validates text field
        validationLabel.isHidden = true
        if (usernameTextField!.text != nil), usernameTextField.text?.count != 0{}
            else{
                validationLabel.isHidden = false
                validationLabel.text = "Please Enter Username"
                return
        }
        if (passwordTextField!.text != nil), passwordTextField.text?.count != 0{}
        else{
            validationLabel.isHidden = false
            validationLabel.text = "Please Enter Password"
            return
        }
    
        //makes api post request to login page and saves the user token to a userdefault
        let loginURL = "https://challenge.myriadapps.com/api/v1/login"
        let params = ["Username": usernameTextField.text,"Password": passwordTextField.text]
        Alamofire.request(loginURL, method: .post, parameters: params as Parameters)
            .responseArray { (response: DataResponse<[User]>) in
                if let result = response.value {
                    for newUser in result{
                        self.storedUser.append(newUser)
                        UserDefaults.standard.set(newUser.token, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        self.viewDidLoad()
                    }
                }
        }
    }
}

