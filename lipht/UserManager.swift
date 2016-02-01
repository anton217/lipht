//
//  UserManager.swift
//  lipht
//
//  Created by Anton Nikolov on 1/31/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import Foundation
import Firebase

class UserManager {
    
    static let instance : UserManager = UserManager()
    let ref : Firebase!
    
    private init() {
        ref = Firebase(url:"https://lipht.firebaseio.com")
    }
    
    func isUsersLoggedIn() -> Bool {
        print(ref.authData)
        return ref.authData != nil
    }
    
}