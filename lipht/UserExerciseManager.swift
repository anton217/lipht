import Foundation
import Firebase

class UserExerciseManager {
    
    static func getUserExercises(completion : (result : UserExerciseResult) -> Void) {
        
        let userID = Constants.firebase.authData.uid
        var userExercises : [UserExercise] = []
        var exerciseSetGroupTuple : [(NSDate, String, UserExerciseSetGroup)] = []
        
        Constants.firebase.childByAppendingPath("userExercises")
            .queryOrderedByChild("userID")
            .queryEqualToValue(userID)
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                let enumerator = snapshot.children
                while let item = enumerator.nextObject() as? FDataSnapshot {
                    
                    let exercise : UserExercise = UserExercise(item: item)
                    userExercises.append(exercise)

                    if containsTuple(exerciseSetGroupTuple, date: exercise.dateTime, exerciseKey: exercise.exerciseKey) {
                        let existingTuple = getTupleByDateAndKey(exerciseSetGroupTuple, date: exercise.dateTime, exerciseKey: exercise.exerciseKey)
                        let entryIndex = self.indexOfEntryInTuple(exerciseSetGroupTuple, tuple: existingTuple)
                        existingTuple.2.exercises.append(exercise)
                        exerciseSetGroupTuple[entryIndex] = existingTuple
                    } else {
                        let newExerciseSetGroup : UserExerciseSetGroup = UserExerciseSetGroup(fdate: exercise.dateTime, fexerciseKey: exercise.exerciseKey)
                        let exerciseTuple = (exercise.dateTime, exercise.exerciseKey, newExerciseSetGroup)
                        exerciseTuple.2.exercises.append(exercise)
                        exerciseSetGroupTuple.append(exerciseTuple)
                    }
                    
                }
                
                exerciseSetGroupTuple = exerciseSetGroupTuple.sort { $0.0.timeIntervalSince1970 > $1.0.timeIntervalSince1970 }
            
                let result : UserExerciseResult = UserExerciseResult()
                result.userExercises = userExercises
                result.userExerciseGroups = exerciseSetGroupTuple
                
                completion(result: result)
            })

        
    }
    
    private static func containsTuple(tupleArray:[(NSDate, String, UserExerciseSetGroup)], date : NSDate, exerciseKey : String) -> Bool {
        return tupleArray.filter{
            self.datesMatch($0.0, date2: date) && $0.1 == exerciseKey
            }.count > 0
    }
    
    private static func getTupleByDateAndKey(tupleArray:[(NSDate, String, UserExerciseSetGroup)], date : NSDate, exerciseKey : String) -> (NSDate, String, UserExerciseSetGroup) {
        return tupleArray.filter{
            self.datesMatch($0.0, date2: date) && $0.1 == exerciseKey
            }.first!
    }
    
    private static func indexOfEntryInTuple(tupleArray:[(NSDate, String, UserExerciseSetGroup)], tuple: (NSDate, String, UserExerciseSetGroup)) -> Int {
        for (index, item) in EnumerateSequence(tupleArray) {
            if item.0 == tuple.0 && item.1 == tuple.1
            {
                return index
            }
        }
        
        return -1
    }
    
    private static func datesMatch(date1 : NSDate, date2 : NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        
        let date1Components = calendar.components([.Year, .Month, .Day], fromDate: date1)
        let date2Components = calendar.components([.Year, .Month, .Day], fromDate: date2)
        
        return date1Components == date2Components
    }
    
}