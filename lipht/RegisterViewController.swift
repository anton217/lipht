//
//  RegisterViewController.swift
//  lipht
//
//  Created by Anton Nikolov on 1/31/16.
//  Copyright © 2016 Anton Nikolov. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    let ref = Firebase(url: "https://lipht.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerClicked() {
        
        let nameString : String = nameTextBox.text!
        let emailString : String = emailTextBox.text!
        let passwordString : String = passwordTextBox.text!
        
        self.ref.createUser(emailString, password: passwordString) { (error: NSError!) in
            if error == nil {
                
                print("User created successfully")
                self.ref.authUser(emailString, password: passwordString,
                    withCompletionBlock: { (error, auth) -> Void in
                        
                        print("User automatically logged in")
                        
                        let newUser = [
                            "uid": auth.uid,
                            "provider": auth.provider,
                            "displayName": nameString
                        ]
                        
                        print("User added to tree")
                        self.ref.childByAppendingPath("users")
                            .childByAppendingPath(auth.uid).setValue(newUser)
                        
                        self.performSegueWithIdentifier("RegisterSuccessSegue", sender: self)
                })
            }
        }
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
