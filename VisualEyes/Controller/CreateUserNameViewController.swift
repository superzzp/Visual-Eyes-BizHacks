//
//  CreateUserNameViewController.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

// This class handles the creation of a username for a new user
class CreateUsernameViewController: UIViewController
{
    // Outlet for the username text field where the user enters their desired username
    @IBOutlet weak var usernameTextField: UITextField!
    
    // Action triggered when the "Next" button is pressed
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        // Ensure that we have a valid authenticated Firebase user
        guard let firUser = Auth.auth().currentUser,
            // Ensure that the username text field is not empty
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        // Create a new user in Firebase with the entered username
        UserService.create(firUser, username: username) { user in
            // If the user creation was successful, proceed
            guard let user = user else { return }
            print("Created new user \(user.username)")
            
            // Transition to the initial view controller of the main storyboard
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}
