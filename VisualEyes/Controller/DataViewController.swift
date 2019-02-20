//
//  DataViewController.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-03.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


class DataViewController: UIViewController,
UINavigationControllerDelegate {
    var userDataD : UserData!
    
    
    @IBOutlet weak var newSessionButton: UIButton!
    
    
    override func viewDidLoad() {
        print("======================================in DATAVIEWCONTtRLWLEER")
        
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        do {
            try! Auth.auth().signOut()
        } catch let error as NSError {
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
        let loginViewController: UIViewController
        if let storyboard = self.storyboard {
            print("=======test 33 ===============")
            loginViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}
