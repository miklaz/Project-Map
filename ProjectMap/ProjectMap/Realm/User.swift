//
//  User.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 14.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
            return "login"
        }
}
