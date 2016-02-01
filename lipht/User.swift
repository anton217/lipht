//
//  User.swift
//  lipht
//
//  Created by Anton Nikolov on 1/31/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email: String
    
    // Initialize from Firebase
    init(authData: FAuthData) {
        uid = authData.uid
        email = authData.providerData["email"] as! String
    }
    
    // Initialize from arbitrary data
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}