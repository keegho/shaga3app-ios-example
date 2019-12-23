//
//  Constants.swift
//  Shaga3 Web
//
//  Created by Kegham Karsian on 12/23/19.
//  Copyright © 2019 Kegham Karsian. All rights reserved.
//

import Foundation

struct Constants {
    
    static var isFirstLaunchDone: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppDefaultKeys.kFirstRun)
        }
        set(newVal) {
            UserDefaults.standard.set(newVal, forKey: AppDefaultKeys.kFirstRun)
            
        }
    }
    
    static var userValueChanged: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppDefaultKeys.kUserValueChanged)
        }
        set(newVal) {
            UserDefaults.standard.set(newVal, forKey: AppDefaultKeys.kUserValueChanged)
            
        }
    }
    
    static var selectedUser: User {
        get {
            let userDefaults = UserDefaults.standard
            let decoded  = userDefaults.data(forKey: AppDefaultKeys.kUser)
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! User
            
            return decodedUser
        }
        set(newVal) {
            print(newVal.name)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: newVal)
            UserDefaults.standard.set(encodedData, forKey: AppDefaultKeys.kUser)
            UserDefaults.standard.synchronize()
           
            Constants.userValueChanged = true
            
            NotificationCenter.default.post(name: .selectedUserChanged, object: nil)
            
        }
    }
    
    struct AppDefaultKeys {
        static let kFirstRun = "firstRun"
        static let kUser = "user"
        static let kUserValueChanged = "uservaluechanged"
    }
    
    static var guest: User {
        get {
            return User(name: "guest", uuid: "guest", signature: "e20d6020cf3659c9cce3c738578fc10782aea1ba11612dd78d98a2b44f044f10")
        }
    }
}
