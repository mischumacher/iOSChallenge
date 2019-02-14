//
//  UserDefaults.swift
//  FargoEventsApp
//
//  Created by Mitchell Schumacher on 2/13/19.
//  Copyright © 2019 Mitch Schumacher. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    func setIsLoggedIn(Value: Bool){
        set(true, forKey: "isLoggedIn")
        synchronize()
    }
    
    func isLoggedIn() -> Bool{
        return bool(forKey: "isLoggedIn")
    }
    
    
}
