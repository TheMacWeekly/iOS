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
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: emailEntry.text!, password: passwordEntry.text!) { user, error in
            if let error = error, user == nil {
                self.showAlert(message: error.localizedDescription, log: "Invalid username or password")
            }
            else{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        if TestableUtils.isEmail(email: emailEntry.text!){
            Auth.auth().createUser(withEmail: emailEntry.text!, password: passwordEntry.text!){ (authResult, error) in
                if let error = error {
                    self.showAlert(message: error.localizedDescription, log: "error creating new user")
                }
                else{
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        if let error = error{
                            self.showAlert(message: error.localizedDescription, log: "error with verication email")
                        }
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        else{
            self.showAlert(message: "incorrect email address format", log: "incorrect email address format")
        }
    }
    
    func showAlert(message: String, log: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Go back", comment: "Default action"), style: .default, handler: { _ in
            NSLog(log)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // is this method used?
    @IBAction func SignOut(_ sender: UIButton) {
        
        if (Auth.auth().currentUser != nil){
            do{
                try Auth.auth().signOut()
            }
            catch let signOutError as NSError {
                self.showAlert(message: signOutError.localizedDescription, log: signOutError.localizedDescription)
            }
            
            GIDSignIn.sharedInstance().signOut()
        }
        else{
            self.showAlert(message: "no user signed in", log: "no user signed in")
        }
        
    }
    
    @IBAction func googleSignIn(_ sender: UIButton){
        GIDSignIn.sharedInstance().signIn()
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handle ScrollView + keyboard interactions
    // code from https://stackoverflow.com/a/45122844/239816
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height + 20
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }

}

