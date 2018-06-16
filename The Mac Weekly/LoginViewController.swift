//
//  LoginViewController.swift
//  The Mac Weekly
//
//  Created by Gabriel Brown on 6/6/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // Listener for FIRAuth object, gets called whenever a user's login state changes
    var handle: AuthStateDidChangeListenerHandle?
    var emailTextFieldDelegate: UITextFieldDelegate!
    var passwordTextFieldDelegate: UITextFieldDelegate!
    
    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        emailTextField.delegate = emailTextFieldDelegate
        passwordTextField.delegate = passwordTextFieldDelegate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: Actions
    @IBAction func login(_ sender: UIButton) {
        
        // TODO: is there a better way to handle unwrapping these optionals?
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if let error = error {
                //TODO: figure out what to show if login doesn't work
                print(error)
            }
        }
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if validateLogin(email: email) {
            // Currently just makes sure email is a mac.edu email,
            // password restrictions etc can be added to validateLogin later
            
            // Send verification email first? What is control flow here?
            
            // NOTE: this automatically signs in this new user
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                if let error = error {
                    //TODO: figure out what to show if login doesn't work
                    print(error)
                }
                else {
                    // Assuming nothing goes wrong with creating/signing in a new user, send them an email
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        
                        
                    }
                }
            }
        }
    }
    
    // Make sure email/password combo is ok to use (doesn't already exist, is mac.edu, etc)
    func validateLogin(email: String) -> Bool {
        
        let pattern = "^[A-Z0-9._%+-]+@macalester.edu$"
        //let pattern = "^\\S+@macalester.edu$"  -- My original version, in case the above has some trouble

        
        // "/S" - nonwhitespace characters- makes sense because emails never have whitespace.
        // The "^" and "$" characters indicate the start and end of the string, ensuring that the whole string must fit this pattern
        // ALSO: two slashes are used here instead of one because swift gets weird about regular expressions
        
        let doesMatch = email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
        
        return doesMatch
        
        
        
        // My attempts to use NSRegularExpression. It seems overkill for something as simple as this, but I'll leave this here for now in case we need it later.
        
//        let regex = try! NSRegularExpression(pattern: pattern, options: [])
//
//        let matches = regex.matches(in: email, options: [], range: NSRange(location: 0, length: email.count))
//
//        // TODO: may need to replace 0 condition with a nil check
//        // If there are no matches or there are multiple
//        if (matches.count == 0) || (matches.count > 1) {
//
//        }
        
    }
    
}
