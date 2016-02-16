//
//  IronUITextField.swift
//  lipht
//
//  Created by Anton Nikolov on 2/15/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
 
    func addBottomBorderLine(color : UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, self.frame.height - 1, self.frame.width, 1.0)
        bottomLine.backgroundColor = color.CGColor
        self.borderStyle = UITextBorderStyle.None
        self.layer.addSublayer(bottomLine)
    }
    
    func addIconImage(icon : UIImage, color : UIColor) {
        let tintableImage = icon.imageWithRenderingMode(.AlwaysTemplate)
        let imageView = UIImageView(image: tintableImage);
        imageView.frame = CGRectMake(0.0, 0.0, tintableImage.size.width+10.0, tintableImage.size.height);
        imageView.contentMode = UIViewContentMode.Left
        imageView.tintColor = color
        self.leftViewMode = UITextFieldViewMode.Always
        self.leftView = imageView;
    }
    
}
