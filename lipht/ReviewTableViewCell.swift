//
//  ReviewTableViewCell.swift
//  lipht
//
//  Created by Anton Nikolov on 1/31/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
