//
//  Singlton.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 31.10.2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import Foundation
import UIKit

class Singlton {
    
    static let shared = Singlton()
    
    var photo = UIImage.init(systemName: "person.circle.fill")
    
    private init() {}
    
}
