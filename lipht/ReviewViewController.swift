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
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.reviewTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        // Do any additional setup after loading the view.
        
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
        return self.userExercises.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ReviewTableViewCell = self.reviewTableView.dequeueReusableCellWithIdentifier("cell") as! ReviewTableViewCell
        
        let exercise : UserExercise = self.userExercises[indexPath.row]
        
        print(exercise)
        cell.exerciseNameLabel.text = exercise.exerciseName
        cell.repsLabel.text = exercise.reps.stringValue
        cell.weightLabel.text = exercise.weight.stringValue
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let exercise : UserExercise = self.userExercises[indexPath.row]
        print(exercise)
    }

    private func loadExercises() {
        
        ref.childByAppendingPath("userExercises")
            .queryOrderedByChild("userID")
            .queryEqualToValue(user.uid)
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                self.userExercises.removeAll()
                
                let enumerator = snapshot.children
                while let item = enumerator.nextObject() as? FDataSnapshot {

                    let exercise = UserExercise(item: item)                    
                    self.userExercises.append(exercise)
                }
                
                self.userExercises = self.userExercises.reverse()
                self.reviewTableView.reloadData()
            })
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
