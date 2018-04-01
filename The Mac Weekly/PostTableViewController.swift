//
//  PostTableViewController.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/4/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import RxSwift
import RxCocoa


class InfinitePostTableView: InfiniteTableView<Post?> {
}

class PostTableViewController: UITableViewController {
    
    var infiniteTableView: InfinitePostTableView {
        return self.tableView as! InfinitePostTableView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infiniteTableView.fetchPage = { (pageNum, pageLen) in
            return TMWAPI.postsAPI.page(pageNum).pageLen(pageLen).loadSingle()
        }
        infiniteTableView.initPageFetcher()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return infiniteTableView.data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
            fatalError("The dequed cell is not an instance of  PostTableViewCell.")
        }
        
        if let post = infiniteTableView.dataAt(index: indexPath.row) {
            cell.loadPost(post)
        } else {
            cell.loadErrorPost()
        }
        
        return cell
    }
 

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowPost":
            guard let postTableCellView = sender as? PostTableViewCell else {
                fatalError()
            }
            
            guard let destination = segue.destination as? PostViewController else {
                fatalError()
            }
            guard let indexPath = tableView.indexPath(for: postTableCellView) else {
                fatalError()
            }
            destination.post = infiniteTableView.dataAt(index: indexPath.row)
        default:
            break
        }
        

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch(identifier) {
        case "ShowPost":
            guard let postTableCellView = sender as? PostTableViewCell else {
                fatalError()
            }
            guard let indexPath = tableView.indexPath(for: postTableCellView) else {
                fatalError()
            }
            let post = infiniteTableView.dataAt(index: indexPath.row)
            return post != nil
        default:
            return true
        }
    }
 
    @IBAction func refreshView(_ sender: UIRefreshControl) {
        var disposer: Disposable?
        if Reachability.isConnectedToNetwork() {
            disposer = infiniteTableView.refresh().drive(onNext: { _ in
                sender.endRefreshing()
                disposer?.dispose()
            })
        } else {
            print("======> Cannot connect to the INTERNET")
            self.alertNoInternet(refresher: sender)
//            sender.endRefreshing()
        }
        
    }
    
    // Pop up an alert if there is no internet connection and ask user to retry
    private func alertNoInternet(refresher: UIRefreshControl) {
        let alertView = UIAlertController(title: "Failed to connect", message: "There is no internet connection. Please check your network and try again.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Retry", style: .destructive, handler: {_ in
            self.refreshView(refresher)
        }))
        self.present(alertView, animated: true, completion: refresher.endRefreshing)
    }
}
