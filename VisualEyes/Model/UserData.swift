//
//  UserData.swift
//  VisualEyes
//
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit

// Class to represent and store user data, including image information, emotions, and demographics
class UserData {
    
    // DateFormatter to format dates into strings
    let formatter = DateFormatter()
    
    // Properties to store user-related data
    var imageURL: String // URL of the user's image
    var imageHeight: CGFloat // Height of the user's image
    
    var creationDate: Date // Date when the data was collected
    
    // Properties to store emotion data
    var fear: Double
    var happiness: Double
    var contempt: Double
    var disgust: Double
    var surprise: Double
    var sadness: Double
    var anger: Double
    var neutral: Double
    var smile: Double
    
    // Properties for gender and age prediction
    var gender: String
    var age: Int
    
    // Properties to store user's focal area (x and y coordinates)
    var xpos: Int
    var ypos: Int
    
    // Computed property to convert UserData into a dictionary format, which can be useful for saving to a database
    var dictValue: [String : Any] {
        // Convert the creation date to a time interval since 1970 (for easy storage)
        let createdAgo = creationDate.timeIntervalSince1970
        
        // Format the creation date into a readable string
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let creationDateAndTime = formatter.string(from: creationDate)
        
        // Return a dictionary representation of the user's data
        return ["face_image_url" : imageURL,
                "face_image_height" : imageHeight,
                "created_at" : creationDateAndTime,
                "em_fear" : fear,
                "em_happiness": happiness,
                "em_contempt" : contempt,
                "em_disgust" : disgust,
                "em_surprise" : surprise,
                "em_sadness" : sadness,
                "em_anger" : anger,
                "em_neutral" : neutral,
                "smile" : smile,
                "gender" : gender,
                "age" : age,
                "focus_x": xpos,
                "focus_y": ypos]
    }
    
    // Default initializer that initializes all properties with default values
    init() {
        // Initialize image properties
        imageURL = ""
        imageHeight = CGFloat()
        
        // Initialize the creation date to the current date and time
        creationDate = Date()
        
        // Initialize emotion properties with default values
        fear = 0.0
        happiness = 0.0
        contempt = 0.0
        disgust = 0.0
        surprise = 0.0
        sadness = 0.0
        anger = 0.0
        neutral = 0.0
        smile = 0.0
        
        // Initialize demographic properties
        gender = ""
        age = 0
        
        // Initialize focal area properties
        xpos = 0
        ypos = 0
    }
    
    // Custom initializer to initialize UserData with specific values
    init(imageURL: String, imageHeight: CGFloat, date: Date, fear: Double, happiness: Double, contempt: Double, disgust: Double, surprise: Double, sadness: Double, anger: Double, neutral: Double, smile: Double, gender: String, age: Int) {
        
        // Set image properties
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        
        // Set the creation date to the provided date
        self.creationDate = date
        
        // Set emotion properties with provided values
        self.fear = fear
        self.happiness = happiness
        self.contempt = contempt
        self.disgust = disgust
        self.surprise = surprise
        self.sadness = sadness
        self.anger = anger
        self.neutral = neutral
        self.smile = smile
        
        // Set demographic properties
        self.gender = gender
        self.age = age
        
        // Set focal area properties (initial values are 0)
        self.xpos = 0
        self.ypos = 0
    }
    
}
