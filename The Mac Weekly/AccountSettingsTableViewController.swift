//
//  AccountSettingsTableViewController.swift
//  The Mac Weekly
//
//  Created by Gabriel Brown on 9/28/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit

class AccountSettingsTableViewController: UITableViewController {

    
    @IBOutlet weak var login_switchAccountButton: UITableViewCell!
    @IBOutlet weak var login_switchAccountLabel: UILabel!
    
    @IBOutlet weak var logout_BlankButton: UITableViewCell!
    @IBOutlet weak var logout_BlankLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        login_switchAccountButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logIn(sender:))))
        
        if (TestableUtils.isLoggedIn()) {
            
            login_switchAccountLabel.text = "Log into another account"
            logout_BlankLabel.text = "Log Out"
            
            logout_BlankButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logOut(sender:))))
        }
        else {
            
            login_switchAccountLabel.text = "Log In"
            logout_BlankLabel.text = ""
    
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Actions
    
    @objc func logOut(sender: UITapGestureRecognizer) {
        
        TestableUtils.logout()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func logIn(sender: UITapGestureRecognizer) {
        
        //TODO: Send user to login page
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(loginViewController, animated: true)
        
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
