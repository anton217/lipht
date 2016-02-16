import Foundation
import UIKit

extension UISearchBar {
    
    func roundCorners(corners : UIRectCorner, radius : CGFloat) {
        let bounds = self.bounds;
        
        let newBounds = CGRectMake(bounds.origin.x,
            bounds.origin.y,
            bounds.size.width - 217,
            bounds.size.height);
        
        let maskPath:UIBezierPath = UIBezierPath(roundedRect: newBounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, radius))
        
        let maskLayer:CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.CGPath
        
        self.layer.mask = maskLayer
        
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.CGPath
        frameLayer.fillColor = nil
        
        self.layer.addSublayer(frameLayer)
    }
    
}