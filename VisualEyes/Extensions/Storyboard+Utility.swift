//
//  Storyboard+Utility.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit

// Extension to the UIStoryboard class to simplify storyboard initialization and view controller instantiation
extension UIStoryboard {
    
    // Enumeration to represent the different types of storyboards in the app
    enum MGType: String {
        case main  // Represents the Main storyboard
        case login // Represents the Login storyboard
        
        // Computed property to return the filename of the storyboard
        var filename: String {
            return rawValue.capitalized // Capitalizes the enum raw value to match the storyboard filenames (e.g., "Main", "Login")
        }
    }
    
    // Convenience initializer to create a UIStoryboard instance for a specific storyboard type
    convenience init(type: MGType, bundle: Bundle? = nil) {
        // Initialize the storyboard with the name derived from the MGType enum and the provided bundle (if any)
        self.init(name: type.filename, bundle: bundle)
    }
    
    // Static method to instantiate the initial view controller for a given storyboard type
    static func initialViewController(for type: MGType) -> UIViewController {
        // Create an instance of UIStoryboard using the custom initializer
        let storyboard = UIStoryboard(type: type)
        
        // Attempt to instantiate the initial view controller from the storyboard
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            // If the initial view controller could not be instantiated, trigger a fatal error with a descriptive message
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        // Return the instantiated view controller
        return initialViewController
    }
}
