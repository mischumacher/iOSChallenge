//
//  SecondNavigationController.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/22/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation
import UIKit

class SecondNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.backItem?.hidesBackButton = true
    }
}
