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
    
    @IBOutlet weak var newSessionButton: UIButton!
    
    
    override func viewDidLoad() {
        print("======================================in DATAVIEWCONTtRLWLEER")
        print(userDataD.age)
        
    }
    
}
