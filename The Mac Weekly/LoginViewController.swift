//
//  LoginViewController.swift
//  The Mac Weekly
//
//  Created by Gabriel Brown on 6/22/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func SignOut(_ sender: UIButton) {
        TestableUtils.logout()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
