//
//  Storyboard+Utility.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-09.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    enum MGType: String {
        case main
        case login
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: MGType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: MGType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        return initialViewController
    }
    
}
