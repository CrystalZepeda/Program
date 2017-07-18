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
    
    
    func handleLogin (){
        
        guard let email = emailAddressLoginButton.text, let password = passwordLoginButton.text
            else {
                
                print("Invalid form")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
                
            }
            
            print("Successful login", user)
            self.performSegue(withIdentifier: "logInToHome", sender: self);
            
            
        })
    }
    
    
    
    @IBAction func FBLoginButtonTapped(_ sender: Any) {
        handleCustomFBLogin()
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err)
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
                print("Failed to start graph request:", err)
                return
            }
            print(result)
        }
    }
}

