//
//  UserExercise.swift
//  lipht
//
//  Created by Anton Nikolov on 1/30/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import Foundation
import Firebase

struct UserExercise {
    
    let userID : String
    let userEmail : String
    var exerciseKey : String
    var exerciseName : String
    var reps : NSNumber = 0
    var weight : NSNumber = 0
    let dateTime : String
    
    init(fuserID : String, fuserEmail : String, fExerciseKey : String, fExerciseName : String, fRepCount : NSNumber, fWeight : NSNumber, fDateTime : String) {
        self.userID = fuserID
        self.userEmail = fuserEmail
        self.exerciseKey = fExerciseKey
        self.exerciseName = fExerciseName
        self.reps = fRepCount
        self.weight = fWeight
        self.dateTime = fDateTime
    }
    
    init(item : FDataSnapshot) {
        self.userID = item.value["userID"] as! String
        self.userEmail = item.value["userEmail"] as! String
        self.exerciseKey = item.value["exerciseKey"] as! String
        self.exerciseName = item.value["exerciseName"] as! String
        self.reps = item.value["reps"] as! NSNumber
        self.weight = item.value["weight"] as! NSNumber
        self.dateTime = item.value["dateTime"] as! String
    }
}

