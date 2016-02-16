//
//  ExerciseStreamViewController.swift
//  lipht
//
//  Created by Anton Nikolov on 1/31/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase
import Charts

class ExerciseStreamViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var rep1Button: UIButton!
    @IBOutlet weak var rep5Button: UIButton!
    @IBOutlet weak var rep10Button: UIButton!
    
    @IBOutlet weak var lineChartView: LineChartView!

    var dates : [NSDate] = []
    var scores : [UserExerciseSetGroup] = []
    
    let red : UIColor = UIColor(colorLiteralRed: 255/255, green: 111/255, blue: 105/255, alpha: 1.0)
    let green : UIColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 166/255, alpha: 1.0)
    let blue : UIColor = UIColor(colorLiteralRed: 41/255, green: 217/255, blue: 194/255, alpha: 1.0)
    
    var sets : [UserExercise] = []
    
    @IBOutlet weak var setTableView: UITableView!
    @IBOutlet weak var lineUnderTitle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTableView.delegate = self
        
        self.rep1Button.layer.borderColor = green.colorWithAlphaComponent(0.2).CGColor
        self.rep5Button.layer.borderColor = red.colorWithAlphaComponent(0.2).CGColor
        self.rep10Button.layer.borderColor = blue.colorWithAlphaComponent(0.2).CGColor
        
        self.lineChartView.delegate = self
        self.lineChartView.descriptionText = ""
        self.lineChartView.descriptionTextColor = UIColor.whiteColor()
        self.lineChartView.gridBackgroundColor = UIColor.darkGrayColor()
        self.lineChartView.noDataText = "No data provided"
        
        UserExerciseManager.getUserExercises() {
            (result : UserExerciseResult) in
            
            for item in result.userExerciseGroups {
                print(item.2.getStrengthScore())
                self.scores.append(item.2)
                self.dates.append(item.0)
            }
            
            self.scores = self.scores.reverse()
            self.dates = self.dates.reverse()
            self.setChartData(self.scores)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : SetTableViewCell = self.setTableView.dequeueReusableCellWithIdentifier("cell")! as! SetTableViewCell
        
        cell.repsLabel.text =  Int(self.sets[indexPath.row].reps).description
        cell.weightLabel.text = self.sets[indexPath.row].weight.stringValue
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func setChartData(values : [UserExerciseSetGroup]) {
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for var i = 0; i < values.count; i++ {
            if i < scores.count {
                yVals1.append(ChartDataEntry(value: scores[i].getStrengthScore(), xIndex: i))
            }

        }
        
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "First Set")
        set1.axisDependency = .Left // Line will correlate with left axis values
        set1.setColor(red) // our line's opacity is 50%
        set1.setCircleColor(UIColor.redColor()) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 0.0 // the radius of the node circle
        set1.highlightColor = UIColor.whiteColor()
        set1.drawCircleHoleEnabled = false
        set1.drawValuesEnabled = false
        
        set1.drawCubicEnabled = true;
        set1.cubicIntensity = 0.17;
        
        let gradientColorsRed : CFArrayRef = [
            red.colorWithAlphaComponent(0.0).CGColor,
            red.colorWithAlphaComponent(0.05).CGColor,
            red.colorWithAlphaComponent(0.5).CGColor,
            red.colorWithAlphaComponent(0.75).CGColor
        ]

        let gradientColorsGreen : CFArrayRef = [
            green.colorWithAlphaComponent(0.0).CGColor,
            green.colorWithAlphaComponent(0.05).CGColor,
            green.colorWithAlphaComponent(0.5).CGColor,
            green.colorWithAlphaComponent(0.75).CGColor
        ]
        let gradientColorsBlue : CFArrayRef = [
            blue.colorWithAlphaComponent(0.0).CGColor,
            blue.colorWithAlphaComponent(0.05).CGColor,
            blue.colorWithAlphaComponent(0.5).CGColor,
            blue.colorWithAlphaComponent(0.75).CGColor
        ]
        
        let gradientRed = CGGradientCreateWithColors(nil, gradientColorsRed, nil)
        let gradientGreen = CGGradientCreateWithColors(nil, gradientColorsGreen, nil)
        let gradientBlue = CGGradientCreateWithColors(nil, gradientColorsBlue, nil)
        
        set1.fillAlpha = 0.4;
        set1.fill = ChartFill.fillWithLinearGradient(gradientRed!, angle: 90)
        set1.drawFilledEnabled = true;
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data: LineChartData = LineChartData(xVals: dates, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        self.lineChartView.data = data

        
        lineChartView.leftAxis.customAxisMin = max(0.0, lineChartView.data!.yMin - 20.0)
        lineChartView.leftAxis.customAxisMax = min(10.0, lineChartView.data!.yMax + 20.0)

        lineChartView.leftAxis.labelCount = Int(lineChartView.leftAxis.customAxisMax - lineChartView.leftAxis.customAxisMin)
        lineChartView.leftAxis.startAtZeroEnabled = false
        
        lineChartView.xAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.xOffset = 0
        lineChartView.xAxis.yOffset = 0
        
        lineChartView.legend.enabled = false
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        self.sets = self.scores[(entry.xIndex)].exercises
        self.setTableView.reloadData()
        
        print("\(entry.value) in \(dates[entry.xIndex])")
    }
    
    @IBAction func rep1Clicked(sender: UIButton) {
        if (sender.selected == false) {
            self.lineChartView.lineData?.dataSets[1].visible = false
            self.lineChartView.setNeedsDisplay()
            sender.selected = true
        }  else {
            self.lineChartView.lineData?.dataSets[1].visible = true
            self.lineChartView.setNeedsDisplay()
            sender.selected = false
        }

    }
    
    @IBAction func rep5Clicked(sender: UIButton) {
        if (sender.selected == false) {
            self.lineChartView.lineData?.dataSets[0].visible = false
            self.lineChartView.setNeedsDisplay()
            sender.selected = true
        }  else {
            self.lineChartView.lineData?.dataSets[0].visible = true
            self.lineChartView.setNeedsDisplay()
            sender.selected = false
        }
    }
    
    @IBAction func rep10Clicked(sender: UIButton) {
        if (sender.selected == false) {
            self.lineChartView.lineData?.dataSets[2].visible = false
            self.lineChartView.setNeedsDisplay()
            sender.selected = true
        }  else {
            self.lineChartView.lineData?.dataSets[2].visible = true
            self.lineChartView.setNeedsDisplay()
            sender.selected = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
