//
//  EmailSignUpViewController.swift
//  ProgramApp
//
//  Created by Crystal Zepeda on 7/18/17.
//  Copyright © 2017 Crystal Zepeda. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI

class EmailSignUpViewController: UIViewController {

    @IBOutlet weak var nameSignUpTextField: UITextField!

    @IBOutlet weak var emailAddressSignUpTextField: UITextField!
    
    @IBOutlet weak var passwordSignUpTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordSignUpTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
   
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        handleRegister()
        return
    }
    
    
    func handleRegister() {
        
        
        guard let email = emailAddressSignUpTextField.text, let password = passwordSignUpTextField.text, let name = nameSignUpTextField.text
            
            else {
                
                print("Invalid form")
                return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                print(error)
                return
                
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://programapp-28cb7.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            
            let values = ["name": name, "email": email]
            
            
            
            
            usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    print(error)
                    return
                    
                }
                print("Saved user successfully into Firebase")
                self.performSegue(withIdentifier: "signUpToHome", sender: self)
                
                
            })
            
            
        })
        
    }




}
