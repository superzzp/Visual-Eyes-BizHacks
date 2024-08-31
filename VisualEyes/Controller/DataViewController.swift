//
//  DataViewController.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

// This class handles the data view, where user data is managed and sessions can be initiated or ended.
class DataViewController: UIViewController, UINavigationControllerDelegate {
    
    // Variable to hold user data
    var userDataD: UserData!
    
    // Outlet for the "New Session" button
    @IBOutlet weak var newSessionButton: UIButton!
    
    // Called when the view has been loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        // This method runs when the view is first loaded
    }
    
    // Action triggered when the "Log Out" button is pressed
    @IBAction func logOut(_ sender: UIButton) {
        do {
            // Attempt to sign out the current authenticated user
            try Auth.auth().signOut()
        } catch let error as NSError {
            // If there's an error during sign out, it will be caught here
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
        
        // If the storyboard is available, navigate back to the login screen
        if let storyboard = self.storyboard {
            let loginViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}