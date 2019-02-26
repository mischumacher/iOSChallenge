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
    
    var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in [usernameTextField, passwordTextField]{
            textField!.delegate = (self as UITextFieldDelegate)
        }
        presenter = LoginPresenter(with: self as LoginView)
        presenter.start()
    }
    
    //Mark: Login Button
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        presenter.login(usernameTextField.text, passwordTextField.text)
    }
}


extension LoginViewController: LoginView{
    
    func showLandingScreen() {
        self.present(presenter.getEvents(), animated: true, completion: nil)
    }
    func showProgress() {
        ProgressSpinner.startSpinner(uiView: view)
    }
    func hideProgress() {
        ProgressSpinner.stopSpinner(uiView: view)
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

