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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //Mark:Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in [usernameTextField, passwordTextField]{
            textField!.delegate = self
        }
    }
    
    //Mark: TextFields
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
        
        
        let params = ["Username": usernameTextField.text,"Password": passwordTextField.text]
        Alamofire.request("https://challenge.myriadapps.com/api/v1/login", method: .post, parameters: params as Parameters)
        self.performSegue(withIdentifier: "mainSegue", sender: nil)
    }
}

