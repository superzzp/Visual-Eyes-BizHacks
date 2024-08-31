//
//  UserSnapPos.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit

// Class to represent the position of the user's eyes in a snapshot, along with the snapshot image
class UserSnapPos {
    
    // Struct to represent the position of the user's eyes in the snapshot
    struct eyePostion {
        var xpos: Double // X-coordinate of the eye position
        var ypos: Double // Y-coordinate of the eye position
    }
    
    // Property to store the snapshot image associated with the user's eye position
    let snapShot: UIImage?
    
    // Default initializer that sets the eye position to (0, 0) and the snapshot image to nil
    init() {
        // Initialize eye position to the default values (0, 0)
        eyePostion.init(xpos: 0, ypos: 0)
        
        // Initialize the snapshot image as nil (no image)
        snapShot = nil
    }
    
    // Custom initializer that sets the eye position and snapshot image to specific values
    init(x: Double, y: Double, image: UIImage) {
        // Initialize eye position with provided x and y coordinates
        eyePostion.init(xpos: x, ypos: y)
        
        // Set the snapshot image to the provided image
        snapShot = image
    }
    
}
