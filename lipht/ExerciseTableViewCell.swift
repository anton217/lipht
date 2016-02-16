//
//  ExerciseTableViewCell.swift
//  lipht
//
//  Created by Anton Nikolov on 2/7/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase

class ExerciseTableViewCell: UITableViewCell {

    var ref = Firebase(url:"https://lipht.firebaseio.com")
    
    weak var exercise : Exercise?
    
    @IBOutlet weak var liftNameLabel: UILabel!
    @IBOutlet weak var leftIndicatorView: UIView!
    
    @IBOutlet weak var repsSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var liftButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initLabels()
        
        self.liftButton.layer.borderColor = UIColor(colorLiteralRed: 255/255, green: 111/255, blue: 105/255, alpha: 0.25).CGColor
        self.liftButton.layer.borderWidth = 2
        self.liftButton.layer.cornerRadius = 5
    }
    
    @IBAction func submitLift(sender: AnyObject) {
        
        let currentDateTime = NSNumber(double: NSDate().timeIntervalSinceReferenceDate)
        
        let userEmail = ref.authData.providerData["email"] as! String
        let userID = ref.authData.uid
        
        let submitExercise : NSDictionary = [
            "userID": userID,
            "userEmail": userEmail,
            "exerciseKey": exercise!.key,
            "exerciseName": exercise!.name,
            "reps": repsSlider.value,
            "weight": weightSlider.value,
            "dateTime": currentDateTime
        ]
        
        ref.childByAppendingPath("/userExercises")
            .childByAutoId()
            .setValue(submitExercise)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initLabels() {
        self.weightLabel.text = String(Int(weightSlider.value))
        self.repsLabel.text = String(Int(repsSlider.value))
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
    
    func load() {
        
    }
}
