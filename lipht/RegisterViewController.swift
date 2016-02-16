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
    @IBOutlet weak var submitButton: UIButton!
    
    let offWhite : UIColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.7)
    let almostClear : UIColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.submitButton.layer.borderColor = UIColor(colorLiteralRed: 150/255, green: 206/255, blue: 180/255, alpha: 0.5).CGColor
        
        self.emailTextBox.attributedPlaceholder = NSAttributedString(string:"email address", attributes:[NSForegroundColorAttributeName: offWhite])
        self.passwordTextBox.attributedPlaceholder = NSAttributedString(string:"password", attributes:[NSForegroundColorAttributeName: offWhite])
        self.nameTextBox.attributedPlaceholder = NSAttributedString(string:"username", attributes:[NSForegroundColorAttributeName: offWhite])
        
        nameTextBox.addBottomBorderLine(almostClear)
        nameTextBox.addIconImage(UIImage(named: "user_icon.png")!, color: offWhite)
        
        emailTextBox.addBottomBorderLine(almostClear)
        emailTextBox.addIconImage(UIImage(named: "message_icon.png")!, color: offWhite)
        
        passwordTextBox.addBottomBorderLine(almostClear)
        passwordTextBox.addIconImage(UIImage(named: "lock_icon.png")!, color: offWhite)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func registerClicked() {
        
        let nameString : String = nameTextBox.text!
        let emailString : String = emailTextBox.text!
        let passwordString : String = passwordTextBox.text!
        
        Constants.firebase.createUser(emailString, password: passwordString) { (error: NSError!) in
            if error == nil {
                
                print("User created successfully")
                Constants.firebase.authUser(emailString, password: passwordString,
                    withCompletionBlock: { (error, auth) -> Void in
                        
                        print("User automatically logged in")
                        
                        let newUser = [
                            "uid": auth.uid,
                            "provider": auth.provider,
                            "displayName": nameString
                        ]
                        
                        print("User added to tree")
                        Constants.firebase.childByAppendingPath("users")
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
