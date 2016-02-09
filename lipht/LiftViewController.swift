//
//  LiftViewController.swift
//  lipht
//
//  Created by Anton Nikolov on 1/30/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class LiftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var selectedExerciseLabel: UILabel!
    @IBOutlet weak var exerciseSearchBar: UISearchBar!
    @IBOutlet weak var repsSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var liftButton: UIButton!
    
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
        initLabels()
        
        self.liftButton.layer.borderColor = UIColor(colorLiteralRed: 255/255, green: 111/255, blue: 105/255, alpha: 0.25).CGColor
        self.liftButton.layer.borderWidth = 2
        self.liftButton.layer.cornerRadius = 5
        
        self.repsSlider.minimumTrackTintColor = UIColor(colorLiteralRed: 150/255, green: 206/255, blue: 180/255, alpha: 0.65)
        self.repsSlider.maximumTrackTintColor = UIColor(colorLiteralRed: 150/255, green: 206/255, blue: 180/255, alpha: 0.65)
        
        self.weightSlider.minimumTrackTintColor = UIColor(colorLiteralRed: 150/255, green: 206/255, blue: 180/255, alpha: 0.65)
        self.weightSlider.maximumTrackTintColor = UIColor(colorLiteralRed: 150/255, green: 206/255, blue: 180/255, alpha: 0.65)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
    
    private func initLabels() {
        self.weightLabel.text = String(Int(weightSlider.value))
        self.repsLabel.text = String(Int(repsSlider.value))
        self.selectedExerciseLabel.text = "select exercise"
    }
    
    @IBAction func submitLift(sender: AnyObject) {
        
        let currentDateTime = NSNumber(double: NSDate().timeIntervalSinceReferenceDate)
        
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
        let cell:ExerciseTableViewCell = self.exerciseTableView.dequeueReusableCellWithIdentifier("cell")! as! ExerciseTableViewCell
        
        let exercise : Exercise = isSearchActive() ?
            filteredExerciseList[indexPath.row] :
            exerciseList[indexPath.row]
        
        cell.liftNameLabel.text = exercise.name
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(colorLiteralRed: 242/255, green: 235/255, blue: 199/255, alpha: 0.05)
        cell.selectedBackgroundView = backgroundView
        cell.liftNameLabel.textColor = UIColor(colorLiteralRed: 242/255, green: 235/255, blue: 199/255, alpha: 1)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let exercise : Exercise = isSearchActive() ?
            filteredExerciseList[indexPath.row] :
            exerciseList[indexPath.row]
        
        self.selectedExercise = exercise
        self.selectedExerciseLabel.text = exercise.name
        
        let cell : ExerciseTableViewCell = self.exerciseTableView.cellForRowAtIndexPath(indexPath) as! ExerciseTableViewCell
        cell.leftIndicatorView.layer.backgroundColor = UIColor(colorLiteralRed: 170/255, green: 216/255, blue: 176/255, alpha: 1).CGColor
        cell.liftNameLabel.textColor = UIColor(colorLiteralRed: 170/255, green: 216/255, blue: 176/255, alpha: 1)
    }
    

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : ExerciseTableViewCell = self.exerciseTableView.cellForRowAtIndexPath(indexPath) as! ExerciseTableViewCell
        cell.liftNameLabel.textColor = UIColor(colorLiteralRed: 242/255, green: 235/255, blue: 199/255, alpha: 1)
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
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
    }
    
    private func initSearchBar() {
        exerciseSearchBar.delegate = self

        let corners = UIRectCorner.TopRight.union(UIRectCorner.TopLeft)
        self.roundCorners(corners, radius: 10)
    }
    
    func roundCorners(corners:UIRectCorner, radius:CGFloat) {
        let bounds = exerciseSearchBar.bounds;
        
        let newBounds = CGRectMake(bounds.origin.x,
            bounds.origin.y,
            bounds.size.width - 217,
            bounds.size.height);
        
        let maskPath:UIBezierPath = UIBezierPath(roundedRect: newBounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, radius))
        
        let maskLayer:CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.CGPath
        
        exerciseSearchBar.layer.mask = maskLayer
        
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.CGPath
        frameLayer.fillColor = nil
        
        exerciseSearchBar.layer.addSublayer(frameLayer)
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
    
    @IBAction func repsValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        self.repsLabel.text = "\(currentValue)"
    }

    @IBAction func weightValueChanged(sender: UISlider) {
        let stepSize : Float = 5
        
        let roundedValue = round(sender.value / stepSize) * stepSize
        self.weightSlider.setValue(roundedValue, animated: false)
        self.weightSlider.value = roundedValue
        
        self.weightLabel.text = String(Int16(roundedValue))
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
