//
//  AzureCognitiveService.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-10.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//
// class for sending or receving data from / to Microsoft Azure Cognitive Service API

import Foundation
import Alamofire
import SwiftyJSON

class AzureCognitiveService {
    
    //let azureURL: String = Constants.Azure.AZUREURL
    //let azureSubscriptionKey: String = Constants.Azure.SUBSCRIPTIONKEY
    
    
    static func azureFaceAnalysis (facePicsUrl: URL?, completion: @escaping (JSON?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Ocp-Apim-Subscription-Key": Constants.Azure.SUBSCRIPTIONKEY,
            ]
        print(facePicsUrl?.absoluteString)
        //some parameters included in Constants.Azure.AZUREURL
        let parameters: Parameters = [
            //            "returnFaceId":true,
            //            "returnFaceLandmarks": false,
            //            "returnFaceAttributes": "age, gender, emotion, hair, makeup, occlusion, accessories, blur",
            "url" : facePicsUrl?.absoluteString
        ]
        
        Alamofire.request(Constants.Azure.AZUREURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                print("successfully get JSON data!")
                let jso: JSON = JSON(response.result.value!)
                //json from azure is returned!
                return completion(jso)
                
                //self.updateUserData(json: jso)
            }else{
                print("fail to get JSON response!")
                return completion(nil)
                //DispatchQueue.main.async {
                //    self.navigationItem.title = "Fail to get image infomation"
                //}
            }
        }
    }
}
