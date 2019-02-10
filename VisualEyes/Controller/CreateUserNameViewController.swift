//
//  CreateUserNameViewController.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-09.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController
{
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            //if username textfield isEmpty, silently return
            !username.isEmpty else { return }
        //create an user(upload user info) to Firebase
        UserService.create(firUser, username: username) { user in
            guard let user = user else {return}
            print("created new user \(user.username)")
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
        }
    }
    
}
