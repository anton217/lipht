//
//  LiftViewController.swift
//  lipht
//
//  Created by Anton Nikolov on 1/30/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase

class LiftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var selectedExerciseLabel: UILabel!
    @IBOutlet weak var exerciseSearchBar: UISearchBar!
    @IBOutlet weak var repsSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    var ref = Firebase(url:"https://lipht.firebaseio.com")
    
    var exerciseList : [Exercise] = []
    var filteredExerciseList : [Exercise] = []
    var selectedExercise : Exercise?
    var user : User!
    let formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerExerciseChangeHandler()
        registerAuthChangeHandler()
        
        initExerciseTable()
        initSearchBar()
        initDateTimeFormatter()
    }
    
    @IBAction func submitLift(sender: AnyObject) {
        let currentDateTime = formatter.stringFromDate(NSDate())

        let submitExercise : NSDictionary = [
            "userID": user.uid,
            "userEmail": user.email,
            "exerciseKey": selectedExercise!.key,
            "exerciseName": selectedExercise!.name,
            "reps": repsSlider.value,
            "weight": weightSlider.value,
            "dateTime": currentDateTime
        ]
        
        ref.childByAppendingPath("/userExercises")
            .childByAutoId()
            .setValue(submitExercise)
    }
    
    private func registerExerciseChangeHandler() {
        
        ref.childByAppendingPath("/exercise")
            .observeEventType(.Value, withBlock: { snapshot in
                print("Exercise was changed - updating all exercises")
                self.updateAllExercises()
            }, withCancelBlock: { error in
                print(error.description)
            })
        
    }
    
    private func updateAllExercises() {
        ref.childByAppendingPath("/exercise")
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                self.exerciseList.removeAll()
            
                let enumerator = snapshot.children
                while let item = enumerator.nextObject() as? FDataSnapshot {
                    let fKey : String = item.key
                    let fName : String = item.value["name"] as! String
                
                    let exercise : Exercise = Exercise(key: fKey, name: fName)
                    self.exerciseList.append(exercise)
                }
            
                print("Exercise loading complete")
                print(self.exerciseList)
                self.exerciseTableView.reloadData()
            })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive() ?
            filteredExerciseList.count :
            exerciseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.exerciseTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let exercise : Exercise = isSearchActive() ?
            filteredExerciseList[indexPath.row] :
            exerciseList[indexPath.row]
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let exercise : Exercise = isSearchActive() ?
            filteredExerciseList[indexPath.row] :
            exerciseList[indexPath.row]
        
        self.selectedExercise = exercise
        self.selectedExerciseLabel.text = exercise.name
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredExerciseList = exerciseList.filter { (exercise) -> Bool in
            return exercise.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
        }
        
        exerciseTableView.reloadData()
    }
    
    private func registerAuthChangeHandler() {
        ref.observeAuthEventWithBlock { authData in
            if authData != nil {
                self.user = User(authData: authData)
            }
        }
    }
    
    private func initExerciseTable() {
        exerciseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
    }
    
    private func initSearchBar() {
        exerciseSearchBar.delegate = self
    }
    
    private func initDateTimeFormatter() {
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
    }
    
    private func isSearchActive() -> Bool {
        return !exerciseSearchBar.text!.isEmpty
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
