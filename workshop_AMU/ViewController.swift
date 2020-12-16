//
//  ViewController.swift
//  workshop_AMU
//
//  Created by Sara Stojanoska on 12/14/20.
//  Copyright © 2020 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBAction func switchPressed(_ sender: Any) {
        if switchOutlet.isOn{
            autoMechButton.isHidden = false
            mechanicButton.isHidden = false
            electricianButton.isHidden = false
        }
        else{
            autoMechButton.isHidden = true
            mechanicButton.isHidden = true
            electricianButton.isHidden = true
        }
    }
    @IBOutlet weak var mechanicLabel: UILabel!
    @IBOutlet weak var UserLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var autoMechButton: UIButton!
    @IBOutlet weak var electricianButton: UIButton!
    @IBOutlet weak var mechanicButton: UIButton!
    @IBAction func buttonPressed(_ sender: UIButton) {
        let activePosition = sender.tag - 1
        if activePosition == 0{
            autoMechButton.isEnabled = false
            electricianButton.isEnabled = false
        }
        else if activePosition == 1{
            autoMechButton.isEnabled = false
            mechanicLabel.isEnabled = false
        }
        else if activePosition == 2{
            mechanicLabel.isEnabled = false
            electricianButton.isEnabled = false
        }
    }
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var signUpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        phoneTextField.isHidden = true
        nameTextField.isHidden = true
        surnameTextField.isHidden = true
        mechanicButton.isHidden = true
        electricianButton.isHidden = true
        autoMechButton.isHidden = true
        switchOutlet.isHidden = true
        mechanicLabel.isHidden = true
        UserLabel.isHidden = true
    }
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func topPressed(_ sender: Any) {
        if emailTextField.text == "" && passwordTextField.text == "" || (nameTextField.text == "" && surnameTextField.text == "" && phoneTextField.text == ""){
        displayAlert(title: "Error in form", message: "You must provide all information")
        }
        else{
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            view.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signUpMode {
                let user = PFUser()
                user.username = emailTextField.text
                user.password = passwordTextField.text
                user.email = emailTextField.text
                user["firstname"] = nameTextField.text
                user["surname"] = surnameTextField.text
                user["phoneNumber"] = phoneTextField.text
                
                user.signUpInBackground { (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let error = error{
                        let errorString = error.localizedDescription
                        self.displayAlert(title: "Error signing up", message: errorString)
                    }else{
                        print("Sign up success!")
                        self.performSegue(withIdentifier: "toDefect", sender: self)
                    }
                }
            }else{
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let error = error {
                        let errorString = error.localizedDescription
                        self.displayAlert(title: "Error loging in", message: errorString)
                    }
                    else{
                        print("Log in success!")
                        self.performSegue(withIdentifier: "toDefect", sender: self)
                    }
                }
            }
        }
    }
    
    @IBAction func bottomPressed(_ sender: Any) {
        if signUpMode{
            signUpMode = false
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
            phoneTextField.isHidden = true
            nameTextField.isHidden = true
            surnameTextField.isHidden = true
            mechanicButton.isHidden = true
            electricianButton.isHidden = true
            autoMechButton.isHidden = true
            switchOutlet.isHidden = true
            mechanicLabel.isHidden = true
            UserLabel.isHidden = true
            
        }else{
            signUpMode = true
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Log In", for: .normal)
            phoneTextField.isHidden = false
            nameTextField.isHidden = false
            surnameTextField.isHidden = false
            mechanicButton.isHidden = true
            electricianButton.isHidden = true
            autoMechButton.isHidden = true
            switchOutlet.isHidden = false
            mechanicLabel.isHidden = false
            UserLabel.isHidden = false
           switchPressed(self)
           
            
        
    }
}

}

