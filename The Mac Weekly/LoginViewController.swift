//
//  LoginViewController.swift
//  The Mac Weekly
//
//  Created by Gabriel Brown on 6/22/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

// Note: this is just meant to serve as a rough example, mostly so
// that you can see how to use the google sign in and other tools

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is essential for our final login view controller!
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func login(_ sender: UIButton) {
        TestableUtils.login(email: emailEntry.text!, password: passwordEntry.text!)
    }
    
    @IBAction func register(_ sender: UIButton) {
        TestableUtils.register(email: emailEntry.text!, password: passwordEntry.text!)
    }
    
    @IBAction func SignOut(_ sender: UIButton) {
        TestableUtils.logout()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



//I made it
