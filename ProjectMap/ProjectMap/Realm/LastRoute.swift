//
//  Route.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 12.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import Foundation
import RealmSwift

class LastRoute: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
}
