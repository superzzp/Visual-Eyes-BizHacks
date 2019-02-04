//
//  DataViewController.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-03.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit

class DataViewController: UIViewController,
UINavigationControllerDelegate {
    var userDataD : UserData!
    
    override func viewDidLoad() {
        print("======================================in DATAVIEWCONTRLWLEER")
        print(userDataD.age)
        
    }
    
}
