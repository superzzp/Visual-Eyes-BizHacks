//
//  UploadService.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-09.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

struct UploadService {
    static func create(for image: UIImage, completion: @escaping (URL?) -> Void) {
        let imageRef = Storage.storage().reference().child("test_image.jpg")
            StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return completion(nil)
            }
            
//            let urlString = downloadURL.absoluteString
            
            //print("image url: \(urlString)")
            print("successfully returned downloadURL in Upload Service")
            return completion(downloadURL)
        }
    }
}
