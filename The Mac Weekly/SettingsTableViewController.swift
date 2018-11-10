//
//  SettingsTableViewController.swift
//  The Mac Weekly
//
//  Created by Gabriel Brown on 9/27/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var accountSettingsButton: UITableViewCell!
    @IBOutlet weak var sendFeedBackButton: UITableViewCell!
    @IBOutlet weak var reportIssueButton: UITableViewCell!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Add gesture recognizers
        accountSettingsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accountSettingsTapped(sender:))))
        sendFeedBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendFeedBack(sender:))))
        reportIssueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reportIssue(sender:))))

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    // MARK: Actions
    
    // Send user to login page if not logged in or continue to account settings
    @objc func accountSettingsTapped(sender: UITapGestureRecognizer) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (TestableUtils.isLoggedIn()) {
            
            let accountSettingsViewController = storyBoard.instantiateViewController(withIdentifier: "AccountSettings") as! AccountSettingsTableViewController
            navigationController?.pushViewController(accountSettingsViewController, animated: true)
        }
        else {
            
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    
    // MARK: Email functions
    
    // Prompts user to write email with [FEEDBACK] in the subject line
    @objc func sendFeedBack(sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController(subject: "[FEEDBACK] [iOS]")
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            showSendMailErrorAlert()
        }
    }
    
    // Prompts user to write email with [ISSUE] in the subject line
    @objc func reportIssue(sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController(subject: "[ISSUE] [iOS]")
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            showSendMailErrorAlert()
        }
    }
    
    
    // Set up mail composition view to send email to themacweeklyapp@gmail.com by default, with the given subject
    func configuredMailComposeViewController(subject: String) -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
        
        mailComposerVC.setToRecipients(["themacweeklyapp@gmail.com"])
        mailComposerVC.setSubject(subject)
        
        return mailComposerVC
    }
    
    
    // Generic email error handler. Would be good to handle different types of errors and
    // give more specific feedback in the future
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send email. Please check your email configuration and try again.", preferredStyle: UIAlertController.Style.actionSheet)
        
        sendMailErrorAlert.show(self, sender: nil)
    }
    
    
    // Called when user either cancels or sends email
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
