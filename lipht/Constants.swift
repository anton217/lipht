import Foundation
import Firebase

struct Constants {
    
    static let firebase : Firebase = Firebase(url: "https://lipht.firebaseio.com")
    
    //textfield constants
    static let textfieldPlaceHolderColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
    
    static let repMaxDictionary : [Int : Double] = [
        1: 1.0,
        2: 0.95,
        3: 0.92,
        4: 0.89,
        5: 0.86,
        6: 0.83,
        7: 0.81,
        8: 0.79,
        9: 0.77,
        10: 0.75,
        11: 0.73,
        12: 0.71,
        13: 0.70,
        14: 0.68,
        15: 0.67,
        16: 0.65,
        17: 0.64,
        18: 0.63,
        19: 0.62,
        20: 0.61,
    ]
}
