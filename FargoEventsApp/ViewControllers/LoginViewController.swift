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

class LoginViewController: BaseViewController{
    
    //Mark:Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var validationLabel: UILabel!
    
    var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in [usernameTextField, passwordTextField]{
            textField!.delegate = self
        }
        presenter = LoginPresenter(with: self)
        presenter.start()
    }
    
    //Mark: Login Button
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        presenter.login(usernameTextField.text, passwordTextField.text)
    }
}


extension LoginViewController: LoginView{
    func showLandingScreen() {
        let navController = UINavigationController(rootViewController: EventsViewController.create(events: presenter.getEvents()))
        navController.navigationBar.barTintColor = UIColor.init(displayP3Red: 3/255, green: 68/255, blue: 106/255, alpha: 1)
        self.present(navController, animated: true, completion: nil)
        validationLabel.isHidden = true
    }
    func DisplayValidationMessage() {
        validationLabel.text = "Please Fill in all text Fields"
        validationLabel.isHidden = false
    }
    func NetworkAlertMessage() {
        let alert = UIAlertController(title: "Connection Failed", message: "Please Check Connection \n and try again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder()
            presenter.login(usernameTextField.text,usernameTextField.text)
        }
        return true
    }
}

