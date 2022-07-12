//
//  Person.swift
//  Project10
//
//  Created by Lorenzo Pesci on 13/03/2020.
//  Copyright © 2020 Lorenzo Pesci. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image:String) {
        self.name = name
        self.image = image
    }

}
