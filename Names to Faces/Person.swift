//
//  Person.swift
//  Names to Faces
//
//  Created by Yohannes Wijaya on 8/21/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
