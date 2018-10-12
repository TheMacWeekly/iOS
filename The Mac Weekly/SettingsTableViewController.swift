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
    
    //var mailComposerVC: MFMailComposeViewController
    
    @IBOutlet weak var accountSettingsButton: UITableViewCell!
    @IBOutlet weak var sendFeedBackButton: UITableViewCell!
    @IBOutlet weak var reportIssueButton: UITableViewCell!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        accountSettingsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accountSettingsTapped(sender:))))
        sendFeedBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendFeedBack(sender:))))
        reportIssueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reportIssue(sender:))))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    // MARK: Actions
    
    // Either send user to login page if not logged in or continue to account settings
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
    
    
    @objc func sendFeedBack(sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController(subject: "[FEEDBACK] [iOS]")
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            showSendMailErrorAlert()
        }
    }
    
    @objc func reportIssue(sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController(subject: "[ISSUE] [iOS]")
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            showSendMailErrorAlert()
        }
    }
    
    
    func configuredMailComposeViewController(subject: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
        
        mailComposerVC.setToRecipients(["themacweeklyapp@gmail.com"])
        mailComposerVC.setSubject(subject)
        //mailComposerVC.setMessageBody("", isHTML: false)    //TODO: check what default is, might not be necessary
        
        return mailComposerVC
    }
    
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send email. Please check your email configuration and try again.", preferredStyle: UIAlertController.Style.actionSheet)
        
        sendMailErrorAlert.show(self, sender: nil)
    }
    
    
    // Called when user eiter cancels or sends email
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
