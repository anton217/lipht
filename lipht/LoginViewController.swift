//
//  ViewController.swift
//  lipht
//
//  Created by Anton Nikolov on 1/30/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let ref = Firebase(url: "https://lipht.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerAuthListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender : AnyObject) {
        
        let emailValue : String? = email.text
        let passwordValue : String? = password.text
        
        ref.authUser(emailValue, password: passwordValue) {
            error, authData in
            if error != nil {
                print("Error trying to login user")
            } else {
                print("User logged in successfully")
                self.performSegueWithIdentifier("LoginSuccessSegue", sender: self)
            }
        }
    }

    private func registerAuthListener() {
        ref.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.performSegueWithIdentifier("LoginSuccessSegue", sender: nil)
            }
        }
    }
    
}

