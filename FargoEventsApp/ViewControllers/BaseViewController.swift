//
//  BaseViewController.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/26/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit


protocol BaseView: class {
    
    func showProgress()
    func hideProgress()

}

class BaseViewController: UIViewController{
    func showProgress(){
         ProgressSpinner.startSpinner(uiView: view)
    }
    func hideProgress() {
         ProgressSpinner.stopSpinner(uiView: view)
    }
}
