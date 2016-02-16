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
    let calendar = NSCalendar.currentCalendar()

    var exerciseSetGroupTuple : [(NSDate, String, UserExerciseSetGroup)] = []
    
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
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseSetGroupTuple.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ReviewTableViewCell = self.reviewTableView.dequeueReusableCellWithIdentifier("cell") as! ReviewTableViewCell

        let exerciseSetGroup = self.exerciseSetGroupTuple[indexPath.row]

        cell.load(exerciseSetGroup.2)
        
        print("-----")
        print(exerciseSetGroup.2.getStrengthScore())
        print(exerciseSetGroup.2.getCoreScore())
        print(exerciseSetGroup.2.getEnduranceScore())
        print("-----")
        
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
        let exerciseSetGroup = self.exerciseSetGroupTuple[indexPath.row].2
        
        if (selectedRow == indexPath.row) {
            return CGFloat(70 + exerciseSetGroup.exercises.count * 25)
        }
        
        return 65
    }
    
    private func loadExercises() {
        
        UserExerciseManager.getUserExercises() {
            (result : UserExerciseResult) in
            
            self.exerciseSetGroupTuple = result.userExerciseGroups
            self.reviewTableView.reloadData()
        }
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
