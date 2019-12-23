//
//  User.swift
//  Shaga3 Web
//
//  Created by Kegham Karsian on 11/11/19.
//  Copyright © 2019 Kegham Karsian. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    var name: String
    var uuid: String
    var signature: String
    
    init(name: String, uuid: String, signature: String) {
        self.name = name
        self.uuid = uuid
        self.signature = signature
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let uuid = aDecoder.decodeObject(forKey: "uuid")as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let signature = aDecoder.decodeObject(forKey: "signature") as! String
        self.init(name: name, uuid: uuid, signature: signature)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(signature, forKey: "signature")
    }
    
}
