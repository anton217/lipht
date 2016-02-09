//
//  ExerciseStreamViewController.swift
//  lipht
//
//  Created by Anton Nikolov on 1/31/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase

class ExerciseStreamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var exerciseStreamTableView: UITableView!
    
    let ref : Firebase = Firebase(url: "https://lipht.firebaseio.com")
    var exerciseStream : [UserExercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exerciseStreamTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.ref.childByAppendingPath("userExercises")
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                
                let exercise = UserExercise(item: snapshot)
                
                self.exerciseStream.insert(exercise, atIndex: 0);
                self.exerciseStreamTableView.reloadData()
                
                }, withCancelBlock: { error in
                    
            })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseStream.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.exerciseStreamTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let exercise : UserExercise = self.exerciseStream[indexPath.row]
        
        cell.textLabel?.text = exercise.userEmail + " " + exercise.weight.stringValue + " " + exercise.reps.stringValue
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let exercise : UserExercise = self.exerciseStream[indexPath.row]
        print(exercise)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
