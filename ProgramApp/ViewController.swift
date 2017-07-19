//
//  ViewController.swift
//  ProgramApp
//
//  Created by Crystal Zepeda on 7/18/17.
//  Copyright © 2017 Crystal Zepeda. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuthUI

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var FBLoginButton: UIButton!
    
    @IBOutlet weak var emailAddressLoginButton: UITextField!
    
    @IBOutlet weak var passwordLoginButton: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        handleLogin()
        return
    }
    
    func alertLogin (title:String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }

        


    
    func handleLogin (){

        
        guard let email = emailAddressLoginButton.text, let password = passwordLoginButton.text
            else {
                
                print("Invalid form")
                return
        }

        if emailAddressLoginButton.text == "" || passwordLoginButton.text == "" {
            
            
            alertLogin(title: "Error", message: "A text field is incomplete")
        }
    
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: email)
        
        if isEmailAddressValid
        {
            print("Email address is valid")
        } else {
            print("Email address is not valid")
            alertLogin(title: "Error", message: "Email address is not valid")
            
            }

        
        Auth.auth().fetchProviders(forEmail: email, completion: { (stringArray, error) in
            if error != nil {
                print(error!)
            } else {
                if stringArray == nil {
                    print("No password. No active account")
                    self.alertLogin(title: "Error", message: "Email address not registered")
                } else {
                    print("There is an active account")
                }
            }
        })
        
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                
                if error!._code == 17009 {
                    self.alertLogin(title: "Error", message: "Incorrect password")
                    print("Yes")
                    
                }
                
                return
                
            }
        
            
            print("Successful login", user!)
            self.performSegue(withIdentifier: "logInToHome", sender: self);
            
            
        })
    }
    
    
    
    @IBAction func FBLoginButtonTapped(_ sender: Any) {
        handleCustomFBLogin()
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err!)
                return
            }
            
            self.showEmailAddress()
            self.performSegue(withIdentifier: "logInToHome", sender: self)
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        showEmailAddress()
    }
    
    func showEmailAddress() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err!)
                return
            }
            print(result!)
        }
    }
}

