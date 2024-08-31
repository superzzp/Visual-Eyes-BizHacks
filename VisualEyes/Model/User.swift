//
//  User.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

// User class that represents the current user of the application, conforming to Codable for easy encoding/decoding
class User: Codable {
    
    // MARK: - Singleton Setup
    
    // 1. Private static variable to hold the current user as a singleton instance
    private static var _current: User?
    
    // 2. Public static variable to access the current user
    static var current: User {
        // 3. Ensure that the current user exists, otherwise throw a fatal error
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4. Return the current user instance
        return currentUser
    }
    
    // MARK: - Properties
    
    // 5. Properties to store the user's unique identifier (uid) and username
    let uid: String
    let username: String
    
    // Initializer to create a new User instance with a uid and username
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
    
    // MARK: - Class Methods
    
    // Method to set the current user and optionally persist it to UserDefaults
    // This method also updates the singleton _current to the provided user
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // If writeToUserDefaults is true, encode the user to data and save it to UserDefaults
        if writeToUserDefaults {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            }
        }
        // Set the _current singleton to the provided user
        _current = user
    }
    
    // MARK: - Initializers
    
    // Failable initializer to handle existing users from a Firebase snapshot
    // If the snapshot doesn't contain a valid uid or username, initialization fails and returns nil
    init?(snapshot: DataSnapshot) {
        // Ensure the snapshot contains a dictionary with a username; if not, return nil
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String else {
                return nil
        }
        // Set the uid from the snapshot key and the username from the dictionary
        self.uid = snapshot.key
        self.username = username
    }
    
}
