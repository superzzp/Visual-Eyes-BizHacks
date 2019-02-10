//
//  UserData.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-03.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation
import UIKit

class UserData {
    
    //image of user
    var imageURL: String
    var imageHeight: CGFloat
    
    //information gathering date
    var creationDate: Date
    
    //emotion data
    var fear : Double
    var happiness : Double
    var contempt : Double
    var disgust : Double
    var surprise : Double
    var sadness : Double
    var anger : Double
    var neutral : Double
    var smile : Double
    
    //gender and age prediction
    var gender: String
    var age : Int
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo,
                "fear" : fear,
            "happiness": happiness,
            "contempt" : contempt,
            "disgust" : disgust,
            "surprise" : surprise,
            "sadness" : sadness,
            "anger" : anger,
            "neutral" : neutral,
            "smile" : smile,
            "gender" : gender,
            "age" : age]
    }
    
    init() {

        imageURL = ""
        imageHeight = CGFloat()
        creationDate = Date()
        fear = 0.0
        happiness = 0.0
        contempt = 0.0
        disgust = 0.0
        surprise = 0.0
        sadness = 0.0
        anger = 0.0
        neutral = 0.0
        smile = 0.0
        gender = ""
        age = 0
    }
    
    
    
    init(imageURL: String, imageHeight: CGFloat, date: Date, fear: Double, happiness: Double, contempt: Double, disgust: Double, surprise: Double, sadness: Double, anger: Double, neutral: Double, smile: Double, gender: String, age: Int) {

        self.imageURL = imageURL
        self.imageHeight = CGFloat()
        self.creationDate = Date()

        self.fear = 0.0
        self.happiness = 0.0
        self.contempt = 0.0
        self.disgust = 0.0
        self.surprise = 0.0
        self.sadness = 0.0
        self.anger = 0.0
        self.neutral = 0.0
        self.smile = 0.0
        self.gender = ""
        self.age = 0
    }
    
    
}
