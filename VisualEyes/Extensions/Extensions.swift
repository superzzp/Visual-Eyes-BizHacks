//
//  Extensions.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import SceneKit

// Extension to add a method for calculating the length (magnitude) of a 3D vector in SceneKit
extension SCNVector3 {
    // Calculate and return the length of the vector
    func length() -> Float {
        // The length is the square root of the sum of the squares of the x, y, and z components
        return sqrtf(x * x + y * y + z * z)
    }
}

// Overloaded subtraction operator for SCNVector3 to allow vector subtraction
func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    // Subtract corresponding components of the two vectors and return the result as a new vector
    return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
}

// Extension to add an average calculation method to collections of CGFloat elements
extension Collection where Element == CGFloat, Index == Int {
    /// Return the mean of a list of CGFloat. Used with `recentVirtualObjectDistances`.
    var average: CGFloat? {
        // Check if the collection is empty; if so, return nil
        guard !isEmpty else {
            return nil
        }
        
        // Calculate the sum of all elements in the collection
        let sum = reduce(CGFloat(0)) { current, next -> CGFloat in
            return current + next
        }
        
        // Return the average by dividing the sum by the count of elements in the collection
        return sum / CGFloat(count)
    }
}
