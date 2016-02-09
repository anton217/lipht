//
//  ExerciseTableViewCell.swift
//  lipht
//
//  Created by Anton Nikolov on 2/7/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var liftNameLabel: UILabel!
    @IBOutlet weak var leftIndicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func load() {
        
    }
}
