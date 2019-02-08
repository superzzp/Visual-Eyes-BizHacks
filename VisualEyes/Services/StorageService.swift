//
//  StorageService.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-07.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import UIKit
import FirebaseStorage

class StorageService {
    //method for uploading images to firebase
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1 convert an UIImage to data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return completion(nil)
        }
        
        // 2 upload data to firebase
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3 error handling
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // 4 call downloadURL to get a URL reference and return it to the completion handler
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
    
}

