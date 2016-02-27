import UIKit
import Firebase
import Toast_Swift

class LiftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var selectedExerciseLabel: UILabel!
    @IBOutlet weak var exerciseSearchBar: UISearchBar!
    
    var ref = Firebase(url:"https://lipht.firebaseio.com")
    
    var exerciseList : [Exercise] = []
    var filteredExerciseList : [Exercise] = []
    var selectedExercise : Exercise?
    var user : User!
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerExerciseChangeHandler()
        registerAuthChangeHandler()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
        
        cell.exercise = exercise;
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedRow == indexPath.row {
            self.selectedRow = -1
        } else {
            self.selectedRow = indexPath.row
        }
        
        let exercise : Exercise = isSearchActive() ?
            filteredExerciseList[indexPath.row] :
            exerciseList[indexPath.row]
        
        self.selectedExercise = exercise
        
        let cell : ExerciseTableViewCell = self.exerciseTableView.cellForRowAtIndexPath(indexPath) as! ExerciseTableViewCell
        cell.leftIndicatorView.layer.backgroundColor = UIColor(colorLiteralRed: 170/255, green: 216/255, blue: 176/255, alpha: 1).CGColor
        cell.liftNameLabel.textColor = UIColor(colorLiteralRed: 170/255, green: 216/255, blue: 176/255, alpha: 1)
        
        //load info for user about lift key
        UserExerciseManager.getUserExercises() {
            (result : UserExerciseResult) in
            
            for item in result.userExerciseGroups {
                print(item.2.getStrengthScore())
            }
        }
    
    
        self.exerciseTableView.beginUpdates()
        self.exerciseTableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (selectedRow == indexPath.row) {
            return 350
        }
        
        return 50
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
    
    private func isSearchActive() -> Bool {
        return !exerciseSearchBar.text!.isEmpty
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
