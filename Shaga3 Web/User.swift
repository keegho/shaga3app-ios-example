//
//  User.swift
//  Shaga3 Web
//
//  Created by Kegham Karsian on 11/11/19.
//  Copyright © 2019 Kegham Karsian. All rights reserved.
//

import Foundation

struct User {
    
    var name: String
    var uuid: String
    
    init(name: String, uuid: String) {
        self.name = name
        self.uuid = uuid
    }
    
}
