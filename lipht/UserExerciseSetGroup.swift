//
//  UserExerciseSetGroup.swift
//  lipht
//
//  Created by Anton Nikolov on 2/5/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import Foundation

class UserExerciseSetGroup {
    
    var date : NSDate
    var exerciseKey : String
    var exercises : [UserExercise]
    
    init(fdate: NSDate, fexerciseKey: String) {
        self.date = fdate
        self.exerciseKey = fexerciseKey
        self.exercises = []
    }
    
    func getStrengthScore() -> Double {
        var score : Double = 0.0
        
        for exercise in exercises {
            score += exercise.getStrengthScore()
        }
        
        score = score / Double(exercises.count)
        
        return score
    }
    
    func getCoreScore() -> Double {
        var score : Double = 0.0
        
        for exercise in exercises {
            score += exercise.getCoreScore()
        }
        
        score = score / Double(exercises.count)
        
        return score
    }
    
    func getEnduranceScore() -> Double {
        var score : Double = 0.0
        
        for exercise in exercises {
            score += exercise.getEnduranceScore()
        }
        
        score = score / Double(exercises.count)
        
        return score
    }
}