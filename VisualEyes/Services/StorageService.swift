//
//  StorageService.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//
// Class for handling image uploads to Firebase Storage

import UIKit
import FirebaseStorage

class StorageService {
    
    // Method for uploading an image to Firebase Storage
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        
        // 1. Convert the UIImage to JPEG data with a compression quality of 0.2
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            // If the conversion fails, return nil in the completion handler
            print("Failed to convert UIImage to JPEG data.")
            return completion(nil)
        }
        
        // 2. Upload the image data to Firebase Storage at the specified reference
        reference.putData(imageData, metadata: nil) { metadata, error in
            
            // 3. Error handling for the upload process
            if let error = error {
                // If there's an error during upload, log it and return nil in the completion handler
                print("Failed to upload image data: \(error.localizedDescription)")
                return completion(nil)
            }
            
            // 4. Retrieve the download URL of the uploaded image
            reference.downloadURL { url, error in
                if let error = error {
                    // If there's an error retrieving the download URL, log it and return nil
                    print("Failed to retrieve download URL: \(error.localizedDescription)")
                    return completion(nil)
                }
                
                // If successful, return the download URL in the completion handler
                completion(url)
            }
        }
    }
}
