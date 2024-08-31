//
//  AzureCognitiveService.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//
// Class for sending and receiving data from/to Microsoft Azure Cognitive Service API

import Foundation
import Alamofire
import SwiftyJSON

class AzureCognitiveService {
    
    // Method to perform face analysis using Azure Cognitive Services
    // Takes a URL of the image to be analyzed and a completion handler to return the JSON response
    static func azureFaceAnalysis(facePicsUrl: URL?, completion: @escaping (JSON?) -> Void) {
        
        // Headers for the API request, including the subscription key for authentication
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Ocp-Apim-Subscription-Key": Constants.Azure.SUBSCRIPTIONKEY
        ]
        
        // Parameters for the API request, including the image URL
        let parameters: Parameters = [
            "url": facePicsUrl?.absoluteString ?? "" // Use the image URL or an empty string if nil
        ]
        
        // Print the URL of the image being analyzed (for debugging purposes)
        print("Analyzing image at URL: \(facePicsUrl?.absoluteString ?? "No URL provided")")
        
        // Perform the API request using Alamofire
        Alamofire.request(Constants.Azure.AZUREURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            // Check if the request was successful
            if response.result.isSuccess {
                print("Successfully retrieved JSON data!")
                
                // Parse the JSON response using SwiftyJSON
                if let value = response.result.value {
                    let json = JSON(value)
                    // Pass the JSON data to the completion handler
                    completion(json)
                } else {
                    // Handle the case where response has no value despite being successful
                    print("Received empty JSON response!")
                    completion(nil)
                }
            } else {
                // Handle the failure to get a JSON response
                print("Failed to retrieve JSON data: \(response.error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
}
