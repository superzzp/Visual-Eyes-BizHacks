//
//  UserData.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-03.
//  Copyright © 2019 Alex Zhang. All rights reserved.
//

import Foundation

class UserData {
    
    var fear : Double
    var happiness : Double
    var contempt : Double
    var disgust : Double
    var surprise : Double
    var sadness : Double
    var anger : Double
    var neutral : Double
    var smile : Double
    var gender: String
    var age : Int
    
    
    init() {
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
    
}
