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
        let m = TestableUtils.login(email: emailEntry.text!, password: passwordEntry.text!)
        
        if (m != ""){
            let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Go back", comment: "Default action"), style: .default, handler: { _ in
                NSLog("Invalid username or password")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        let m = TestableUtils.register(email: emailEntry.text!, password: passwordEntry.text!)
        
        let alert = UIAlertController(title: "Error", message: m, preferredStyle: .alert)
        
        if (m != ""){
            alert.addAction(UIAlertAction(title: NSLocalizedString("Go back", comment: "Default action"), style: .default, handler: { _ in
                NSLog(m)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func SignOut(_ sender: UIButton) {
        let m = TestableUtils.logout()
        let alert = UIAlertController(title: "Error", message: m, preferredStyle: .alert)
        
        if (m != ""){
            alert.addAction(UIAlertAction(title: NSLocalizedString("Go back", comment: "Default action"), style: .default, handler: { _ in
                NSLog(m)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func googleSignIn(_ sender: UIButton){
        GIDSignIn.sharedInstance().signIn()
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

