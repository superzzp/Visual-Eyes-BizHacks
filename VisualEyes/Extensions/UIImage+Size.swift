//
//  UIImage+Size.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import UIKit

// Extension to the UIImage class to add functionality for calculating aspect height
extension UIImage {
    
    // Computed property to calculate the aspect height of the image based on the dimensions of the device
    // The device dimensions used here are specific to the iPad Pro 11-inch (1112 x 834)
    var aspectHeight: CGFloat {
        // Calculate the height ratio by dividing the image's height by the device's height (1112)
        let heightRatio = size.height / 1112
        
        // Calculate the width ratio by dividing the image's width by the device's width (834)
        let widthRatio = size.width / 834
        
        // Determine the maximum of the two ratios (heightRatio, widthRatio)
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        // Calculate and return the adjusted height of the image based on the aspect ratio
        return size.height / aspectRatio
    }
}
