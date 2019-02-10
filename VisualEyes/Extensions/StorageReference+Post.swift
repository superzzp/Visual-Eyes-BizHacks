//
//  StorageReference.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-10.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation
import FirebaseStorage

// generate a new location for each new post image that is created by the current ISO timestamp.
extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
