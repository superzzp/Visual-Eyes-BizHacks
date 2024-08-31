//
//  UploadService.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//
// Class for handling image uploads, performing face analysis using Azure Cognitive Services, and storing the results in Firebase
import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import SwiftyJSON

struct UploadService {
    
    // Method to create and upload an image, perform face analysis, and store the results in Firebase
    static func create(for image: UIImage, xpos: String?, ypos: String?, completion: @escaping (URL?) -> Void) {
        
        // Generate a unique reference for the image upload based on the user's UID and current time
        let imageRef = StorageReference.newPostImageReference()
        
        // Upload the image to Firebase Storage
        StorageService.uploadImage(image, at: imageRef) { downloadURL in
            guard let downloadURL = downloadURL else {
                // If the image upload fails, return nil
                return completion(nil)
            }
            
            // Print success message for debugging
            print("Successfully returned downloadURL in Upload Service")
            
            // Perform face analysis using the uploaded image's URL
            AzureCognitiveService.azureFaceAnalysis(facePicsUrl: downloadURL) { json in
                guard let json = json else {
                    // If face analysis fails, return nil
                    print("Failed to get JSON data from Azure")
                    return completion(nil)
                }
                
                // Create a UserData model to store the analysis results
                let userDataModel = UserData()
                
                // Parse the age from the JSON response
                userDataModel.age = json[0]["faceAttributes"]["age"].intValue
                if userDataModel.age == 0 {
                    // If no face is detected, return nil
                    print("Face not detected in this shot")
                    return completion(nil)
                }
                
                // Parse the x and y positions if provided
                if let userXpos = xpos {
                    userDataModel.xpos = Int(userXpos) ?? 0
                }
                if let userYpos = ypos {
                    userDataModel.ypos = Int(userYpos) ?? 0
                }
                
                // Parse additional attributes using SwiftyJSON
                userDataModel.gender = json[0]["faceAttributes"]["gender"].stringValue
                userDataModel.neutral = json[0]["faceAttributes"]["emotion"]["neutral"].doubleValue
                userDataModel.happiness = json[0]["faceAttributes"]["emotion"]["happiness"].doubleValue
                userDataModel.anger = json[0]["faceAttributes"]["emotion"]["anger"].doubleValue
                userDataModel.disgust = json[0]["faceAttributes"]["emotion"]["disgust"].doubleValue
                userDataModel.fear = json[0]["faceAttributes"]["emotion"]["fear"].doubleValue
                userDataModel.sadness = json[0]["faceAttributes"]["emotion"]["sadness"].doubleValue
                userDataModel.contempt = json[0]["faceAttributes"]["emotion"]["contempt"].doubleValue
                userDataModel.surprise = json[0]["faceAttributes"]["emotion"]["surprise"].doubleValue
                userDataModel.smile = json[0]["faceAttributes"]["smile"].doubleValue

                
                // Calculate the aspect height based on the physical size of the device
                let aspectHeight = image.aspectHeight
                
                // Save the data to Firebase Database
                create(forURLString: downloadURL.absoluteString, aspectHeight: aspectHeight, userDataModel: userDataModel)
                
                // Return the download URL upon successful completion
                return completion(downloadURL)
            }
        }
    }
    
    // Private method to save the analyzed data to Firebase Database
    private static func create(forURLString urlString: String, aspectHeight: CGFloat, userDataModel: UserData) {
        // Get the current user
        let currentUser = User.current
        
        // Update user data with the image URL and aspect height
        userDataModel.imageURL = urlString
        userDataModel.imageHeight = aspectHeight
        
        // Transform the UserData model into a dictionary format
        let dict = userDataModel.dictValue
        
        // Create a new child reference in the Firebase Database for storing the analysis
        let postRef = Database.database().reference().child("Analysis").child(currentUser.uid).childByAutoId()
        
        // Save the user data to the database
        postRef.updateChildValues(dict)
    }
}
