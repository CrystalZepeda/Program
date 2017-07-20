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
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        handleRegister()
        return
    }
    
    func alert (title:String, message: String) {
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    let minimumCharacterCount = 8
  


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
    
    return returnValue
}

    func handleRegister() {
        
        guard let email = emailAddressSignUpTextField.text, let password = passwordSignUpTextField.text, let name = nameSignUpTextField.text, let confirmPassword = confirmPasswordSignUpTextField.text, let receivedP = emailAddressSignUpTextField.text
            else {
                
                print("Invalid form")
                return
        }
        
    if emailAddressSignUpTextField.text == "" || nameSignUpTextField.text == "" {
        
            
            alert(title: "Error", message: "A text field is incomplete")
        }
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: email)
        
        if isEmailAddressValid
        {
            print("Email address is valid")
        } else {
            print("Email address is not valid")
            alert(title: "Error", message: "Email address is not valid")
            
        }
        
        Auth.auth().fetchProviders(forEmail: email, completion: { (stringArray, error) in
            if error != nil {
                print(error!)
            } else {
                if stringArray == nil {
                    print("No password. No active account")
                } else {
                    print("There is an active account")
                    self.alert(title: "Error", message: "Email address already in use")
                }
            }
        })
        
        if passwordSignUpTextField.text == "" || confirmPasswordSignUpTextField.text == "" {
            
            alert(title: "Error", message: "Password is incomplete")
        }
        
        if  password.characters.count < minimumCharacterCount {
            alert(title: "Error", message: "Passwords need at least 8 characters")
        }
        
        
        if password != confirmPassword && (password != "" && confirmPassword != ""){
            alert(title: "Error", message: "Passwords do not match")
        }
        
       
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                print(error!)
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
                    print(error!)
                    return
                    
                }
                print("Saved user successfully into Firebase")
                self.performSegue(withIdentifier: "signUpToHome", sender: self)

                
            })
            
            
        })
        
    }




}
