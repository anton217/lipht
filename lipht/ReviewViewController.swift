//
//  ReviewViewController.swift
//  lipht
//
//  Created by Anton Nikolov on 1/30/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reviewTableView: UITableView!
    
    var ref : Firebase = Firebase(url:"https://lipht.firebaseio.com")
    var user : User!
    var userExercises : [UserExercise] = []
    let formatter = NSDateFormatter()
    
    var selectedRow : NSNumber = -1
    
    var exerciseSetGroupDictionary : [String : UserExerciseSetGroup] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy.MM.dd G 'at' HH:mm:ss zzz"
        
        ref.observeAuthEventWithBlock { authData in
            if authData != nil {
                self.user = User(authData: authData)
                
                self.ref.childByAppendingPath("userExercises")
                    .observeEventType(.Value, withBlock: { snapshot in
                        self.loadExercises()
                        }, withCancelBlock: { error in
                            
                    })
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseSetGroupDictionary.values.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ReviewTableViewCell = self.reviewTableView.dequeueReusableCellWithIdentifier("cell") as! ReviewTableViewCell

        let exerciseSetGroup = Array(self.exerciseSetGroupDictionary.values)[indexPath.row]

        cell.load(exerciseSetGroup)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedRow == indexPath.row {
            self.selectedRow = -1
        } else {
            self.selectedRow = indexPath.row
        }

        self.reviewTableView.beginUpdates()
        self.reviewTableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let exerciseSetGroup = Array(self.exerciseSetGroupDictionary.values)[indexPath.row]
        
        if (selectedRow == indexPath.row) {
            return CGFloat(70 + exerciseSetGroup.exercises.count * 25)
        }
        
        return 65
    }
    
    private func loadExercises() {
        
        ref.childByAppendingPath("userExercises")
            .queryOrderedByChild("userID")
            .queryEqualToValue(user.uid)
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                self.userExercises.removeAll()
                self.exerciseSetGroupDictionary.removeAll()
                
                let enumerator = snapshot.children
                while let item = enumerator.nextObject() as? FDataSnapshot {

                    let exercise = UserExercise(item: item)                    
                    self.userExercises.append(exercise)
                    
                    let generatedKey = self.createExerciseSetGroupKey(exercise)
                    
                    if self.exerciseSetGroupDictionary.keys.contains(generatedKey) {
                        var exerciseSetGroup = self.exerciseSetGroupDictionary[generatedKey]
                        exerciseSetGroup?.exercises.append(exercise)
                        self.exerciseSetGroupDictionary[generatedKey] = exerciseSetGroup
                    } else {
                        var newExerciseSetGroup = UserExerciseSetGroup(fdate: exercise.dateTime, fexerciseKey: exercise.exerciseKey)
                        newExerciseSetGroup.exercises.append(exercise)
                        self.exerciseSetGroupDictionary[generatedKey] = newExerciseSetGroup
                    }
                    
                }
                
                self.userExercises = self.userExercises.reverse()
                self.reviewTableView.reloadData()
            })
    }
    
    private func createExerciseSetGroupKey(exercise : UserExercise) -> String {
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let dateString = formatter.stringFromDate(exercise.dateTime)

        return dateString + "-" + exercise.exerciseKey
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
