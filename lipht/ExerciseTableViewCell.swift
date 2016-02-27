//
//  ExerciseTableViewCell.swift
//  lipht
//
//  Created by Anton Nikolov on 2/7/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase

class ExerciseTableViewCell: UITableViewCell, UIScrollViewDelegate {

    var ref = Firebase(url:"https://lipht.firebaseio.com")
    
    weak var exercise : Exercise?
    
    @IBOutlet weak var liftNameLabel: UILabel!
    @IBOutlet weak var leftIndicatorView: UIView!
    
    @IBOutlet weak var repsSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var liftButton: UIButton!
    
    @IBOutlet weak var scrollLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initLabels()
        
        self.liftButton.layer.borderColor = UIColor(colorLiteralRed: 255/255, green: 111/255, blue: 105/255, alpha: 0.25).CGColor
        self.liftButton.layer.borderWidth = 2
        self.liftButton.layer.cornerRadius = 5
        
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        //2
        scrollLabel.text = "bench press"
        scrollLabel.textColor = .blackColor()
        //3
        let pageOne = UIView(frame: CGRectMake(0, 0,scrollViewWidth, scrollViewHeight))
        let pageTwo = UIView(frame: CGRectMake(scrollViewWidth, 0,scrollViewWidth, scrollViewHeight))
        let pageThree = UIView(frame: CGRectMake(scrollViewWidth*2, 0,scrollViewWidth, scrollViewHeight))
        let pageFour = UIView(frame: CGRectMake(scrollViewWidth*3, 0,scrollViewWidth, scrollViewHeight))
        
        self.scrollView.addSubview(pageOne)
        self.scrollView.addSubview(pageTwo)
        self.scrollView.addSubview(pageThree)
        self.scrollView.addSubview(pageFour)
        //4
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
//        if Int(currentPage) == 0{
//            textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
//        }else if Int(currentPage) == 1{
//            textView.text = "I write mobile tutorials mainly targeting iOS"
//        }else if Int(currentPage) == 2{
//            textView.text = "And sometimes I write games tutorials about Unity"
//        }else{
//            textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
//            // Show the "Let's Start" button in the last slide (with a fade in animation)
//            UIView.animateWithDuration(1.0, animations: { () -> Void in
//                self.startButton.alpha = 1.0
//            })
//        }
    }
    
    
}
