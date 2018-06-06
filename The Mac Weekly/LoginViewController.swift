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
        
        if validateLogin(email: email, pass: password) {
            
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                if let error = error {
                    //TODO: figure out what to show if login doesn't work
                    print(error)
                }
                
            }
        }
    }
    
    // Make sure email/password combo is ok to use (doesn't already exist, is mac.edu, etc)
    func validateLogin(email: String, pass: String) -> Bool {
        
        // TODO: Check everything we need to and make sure nothing fishy goes on with email and password. Return false if any test fails.
        
        return true
    }
    
}
