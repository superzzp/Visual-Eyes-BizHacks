//
//  StorageReference.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import Foundation
import FirebaseStorage

// Extension to Firebase StorageReference for generating a new storage location for each post image
extension StorageReference {
    // ISO8601DateFormatter is used to format the current date and time into a string
    static let dateFormatter = ISO8601DateFormatter()
    
    // This function generates a new storage reference for a post image
    static func newPostImageReference() -> StorageReference {
        // Get the unique identifier (uid) of the current user
        let uid = User.current.uid
        
        // Get the current date and time as a string formatted in ISO 8601 format
        let timestamp = dateFormatter.string(from: Date())
        
        // Create a new storage reference for the image, including the user's uid and the current timestamp in the file path
        // The image will be stored in the "images/posts/{uid}/{timestamp}.jpg" path in Firebase Storage
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}