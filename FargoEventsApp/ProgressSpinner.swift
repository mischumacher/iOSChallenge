//
//  ProgressSpinner.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/26/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit

class  ProgressSpinner {
    static var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    
    static func startSpinner(uiView: UIView){
        
        spinner.color = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        uiView.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: uiView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: uiView.centerYAnchor).isActive = true
    }
    
    static func stopSpinner(uiView: UIView){
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
}
