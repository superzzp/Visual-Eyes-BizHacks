//
//  UserSnapPos.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-07.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit

class UserSnapPos {
    
    struct eyePostion {
        var xpos: Double
        var ypos: Double
    }
    
    let snapShot: UIImage?
    
    init() {
        eyePostion.init(xpos: 0, ypos: 0)
        snapShot = nil
    }
    
    init(x: Double, y: Double, image: UIImage) {
        eyePostion.init(xpos: x, ypos: y)
        snapShot = image
    }
    
}
