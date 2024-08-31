//
//  UserService.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//
// Class for handling user-related operations such as creating a new user, retrieving user data from Firebase, and setting the current user

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct UserService {
    
    // Method to create a new user with the given username, save the user record to Firebase, and set the current user
    static func create(_ firUser: User, username: String, completion: @escaping (User?) -> Void) {
        // Dictionary containing the user's attributes to be saved in Firebase
        let userAttrs = ["username": username]
        
        // Reference to the specific user in the Firebase Database
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        // Save the user attributes to the Firebase Database
        ref.setValue(userAttrs) { error, ref in
            if let error = error {
                // Handle the error if the data saving fails
                print("Error saving user data: \(error.localizedDescription)")
                return completion(nil)
            }
            
            // Once the data is saved, retrieve the user's data from Firebase
            ref.observeSingleEvent(of: .value) { snapshot in
                // Initialize a User object using the snapshot
                guard let user = User(snapshot: snapshot) else {
                    return completion(nil)
                }
                
                // Set the current user using the singleton pattern
                User.setCurrent(user)
                
                // Return the newly created user in the completion handler
                completion(user)
            }
        }
    }
    
    // Method to retrieve a user's data from Firebase based on their UID
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        // Reference to the specific user in the Firebase Database
        let ref = Database.database().reference().child("users").child(uid)
        
        // Observe the user's data once and return it
        ref.observeSingleEvent(of: .value) { snapshot in
            // Initialize a User object using the snapshot
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            // Return the retrieved user in the completion handler
            completion(user)
        }
    }
}
