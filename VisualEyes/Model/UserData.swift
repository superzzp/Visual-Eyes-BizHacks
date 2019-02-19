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
    
    let formatter = DateFormatter()
    
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
    
    //user focal area
    var xpos: Int
    var ypos: Int
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let creationDateAndTime = formatter.string(from: creationDate)
        
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
        xpos = 0
        ypos = 0
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
        self.xpos = 0
        self.ypos = 0
    }
    
    
}
