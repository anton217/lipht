import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    let almostClear : UIColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerAuthListener()
        finishStylingButtons()
        finishStylingTextFields()
    }
    
    private func finishStylingButtons() {
        self.loginButton.layer.borderColor = UIColor(colorLiteralRed: 150/255, green: 206/255, blue: 180/255, alpha: 0.5).CGColor
        self.registerButton.layer.borderColor = UIColor(colorLiteralRed: 255/255, green: 204/255, blue: 92/255, alpha: 0.5).CGColor
    }
    
    private func finishStylingTextFields() {
        email.attributedPlaceholder = NSAttributedString(string:"email address", attributes:[NSForegroundColorAttributeName: Constants.textfieldPlaceHolderColor])
        password.attributedPlaceholder = NSAttributedString(string:"password", attributes:[NSForegroundColorAttributeName: Constants.textfieldPlaceHolderColor])

        email.addBottomBorderLine(almostClear)
        password.addBottomBorderLine(almostClear)
        
        email.addIconImage(UIImage(named: "message_icon.png")!, color: Constants.textfieldPlaceHolderColor)
        password.addIconImage(UIImage(named: "lock_icon.png")!, color: Constants.textfieldPlaceHolderColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func login(sender : AnyObject) {
        
        let emailValue : String? = email.text
        let passwordValue : String? = password.text
        
        Constants.firebase.authUser(emailValue, password: passwordValue) {
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
        Constants.firebase.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.performSegueWithIdentifier("LoginSuccessSegue", sender: nil)
            }
        }
    }
    
}

