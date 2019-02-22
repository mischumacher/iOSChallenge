//
//  UserDefaults.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/13/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    func setLaunchStatus(){
        set(true, forKey: "isFirstLaunch")
    }
    
    func isFirstLaunch() -> Bool{
        return bool(forKey: "isFirstLaunch")
    }
    
    
}
