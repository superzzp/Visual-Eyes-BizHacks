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
import SwiftyJSON

struct UploadService {
    
    
    
    static func create(for image: UIImage, completion: @escaping (URL?) -> Void) {
        //generate a unique imageRef for every uploads based on the UID and current time
        let imageRef = StorageReference.newPostImageReference()
            StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return completion(nil)
            }
            
            let urlString = downloadURL.absoluteString
            
            //print("image url: \(urlString)")
            print("successfully returned downloadURL in Upload Service")
            
            AzureCognitiveService.azureFaceAnalysis(facePicsUrl: downloadURL, completion: { json in
     
                if let jso = json {
                    //print out the returned json for testing
                    print("==============json data in Upload service =======")
                    print(jso)
                    let userDataModel = UserData()
                    userDataModel.age = jso[0]["faceAttributes"]["age"].intValue
                    if userDataModel.age == 0 {
                        print("face not detected in this shot")
                        return completion(nil)
                    }
                    userDataModel.gender = jso[0]["faceAttributes"]["gender"].stringValue
                    userDataModel.neutral = jso[0]["faceAttributes"]["emotion"]["neutral"].doubleValue
                    userDataModel.happiness = jso[0]["faceAttributes"]["emotion"]["happiness"].doubleValue
                    userDataModel.anger = jso[0]["faceAttributes"]["emotion"]["anger"].doubleValue
                    userDataModel.disgust = jso[0]["faceAttributes"]["emotion"]["disgust"].doubleValue
                    userDataModel.fear = jso[0]["faceAttributes"]["emotion"]["fear"].doubleValue
                    userDataModel.sadness = jso[0]["faceAttributes"]["emotion"]["sadness"].doubleValue
                    userDataModel.contempt = jso[0]["faceAttributes"]["emotion"]["contempt"].doubleValue
                    userDataModel.surprise = jso[0]["faceAttributes"]["emotion"]["surprise"].doubleValue
                    print("==============json data in Upload service =======")
                    print("gender: \(userDataModel.gender)")
                    
                    let urlString = downloadURL.absoluteString
                    //calculate the aspect height base on the physical size of the device
                    let aspectHeight = image.aspectHeight
                    create(forURLString:urlString, aspectHeight: aspectHeight, userDataModel: userDataModel)
                    return completion(downloadURL)
                    
                }else{
                    print("fail to get json data from Azure")
                    return completion(nil)
                }
            })
        }
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat, userDataModel: UserData) {
        // find the current user
        let currentUser = User.current
        // get the userdate
        let userData = userDataModel
        // add image url to userData
        userData.imageURL = urlString
        // add image height to the image for future display
        userData.imageHeight = aspectHeight
        // transform an object to json format
        let dict = userData.dictValue
        //childByAutoId generates a new child location using a unique key and returns a FIRDatabaseReference to it. This is useful when the children of a Firebase Database location represent a list of items.
        let postRef = Database.database().reference().child("Analysis").child(currentUser.uid).childByAutoId()
        
        postRef.updateChildValues(dict)
    }
}
