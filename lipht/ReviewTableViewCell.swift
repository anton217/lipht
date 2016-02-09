//
//  ReviewTableViewCell.swift
//  lipht
//
//  Created by Anton Nikolov on 1/31/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit

class ReviewTableViewCell : UITableViewCell {
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let formatter = NSDateFormatter()
    let repColor = UIColor.init(colorLiteralRed: 255/255, green: 204/255, blue: 92/255, alpha: 1)
    let weightColor = UIColor.init(colorLiteralRed: 150/255, green: 206/255, blue: 180/255, alpha: 1)
    let setColor = UIColor.init(colorLiteralRed: 52/255, green: 136/255, blue: 153/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func load(fUserExerciseGroup : UserExerciseSetGroup) {
        exerciseNameLabel.text = fUserExerciseGroup.exercises[0].exerciseName
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let formattedDate : String = formatter.stringFromDate(fUserExerciseGroup.exercises[0].dateTime)
        dateLabel.text = formattedDate

        drawReps(fUserExerciseGroup.exercises)
        drawSets(fUserExerciseGroup.exercises.count)
    }
    
    private func drawReps(exercises: [UserExercise]) {
        for index in 0...exercises.count-1 {
            
            let repYLocation = CGFloat(70 + (index * 25))
            let repWidth = CGFloat(10 * exercises[index].reps.integerValue)
            
            let weightYLocation = CGFloat(80 + (index * 25))
            let weightWidght = CGFloat(5 * exercises[index].reps.integerValue)
            
            let repView = UIView(frame: CGRectMake(58, repYLocation, repWidth, 8))
            repView.backgroundColor = repColor
            repView.layer.cornerRadius=4
            self.addSubview(repView)
            
            let weightView = UIView(frame: CGRectMake(58, weightYLocation, weightWidght, 8))
            weightView.backgroundColor = weightColor
            weightView.layer.cornerRadius=4
            self.addSubview(weightView)
        }

    }
    
    private func drawSets(count: Int) {
        for index in 0...count-1 {
            
            let xLocation = CGFloat(60 + (index * 18))
            
            let setView = UIView(frame: CGRectMake(xLocation, 40, 15, 15))
            setView.backgroundColor = setColor
            setView.layer.cornerRadius=7.5
            self.addSubview(setView)
        }
    }

}
