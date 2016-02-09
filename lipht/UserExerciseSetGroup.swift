//
//  UserExerciseSetGroup.swift
//  lipht
//
//  Created by Anton Nikolov on 2/5/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import Foundation

struct UserExerciseSetGroup {
    
    var date : NSDate
    var exerciseKey : String
    var exercises : [UserExercise]
    
    init(fdate: NSDate, fexerciseKey: String) {
        self.date = fdate
        self.exerciseKey = fexerciseKey
        self.exercises = []
    }
    
}