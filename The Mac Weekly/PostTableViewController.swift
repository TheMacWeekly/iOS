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

class PostTableViewController: UITableViewController {
    
    
    var posts: [Post?] = []
    var requests: [DataRequest] = []
    var page = 0
    
    let infinitescroll_margin = 20
    
    func refresh(completion: @escaping ([Post?]) -> Void = {_ in }) {
        requests.forEach {request in
            request.cancel()
        }
        requests = []
        posts = []
        page = 0
        
        self.tableView.reloadData()
        
        nextPage(completion: completion)
    }
    
    func removeExpiredRequests() {
        requests = requests.filter { request in
            return !request.progress.isFinished
        }
    }
    
    func nextPage(completion: @escaping ([Post?]) -> Void = { _ in }) {
        removeExpiredRequests()
        if requests.count == 0 {
            let nextPage = page + 1
            
            requests.append(getPosts(nextPage) { posts in
                if posts.count > 0 {
                    self.posts += posts
                    self.page = nextPage
                    self.tableView.reloadData()
                    completion(posts)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextPage()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > self.posts.count - self.infinitescroll_margin {
            self.nextPage()
        }
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
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
            fatalError("The dequed cell is not an instance of  PostTableViewCell.")
        }
        if let post = posts[indexPath.row] {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YY"
            cell.dateLabel.text = formatter.string(from: post.time)
            cell.authorNameLabel.text = post.author != nil ? ("By \(post.author!.name)" as String?) : (nil as String?)
            cell.titleLabel.text = post.title
            cell.previewLabel.text = String(post.body.prefix(140))
            cell.thumbnailContainer.isHidden = false
            post.thumbnail { thumbnail in
                if let thumbnail = thumbnail {
                    cell.thumbnailView.image = thumbnail
                    cell.thumbnailView.layer.cornerRadius = 5
                    cell.thumbnailProgress.isHidden = true
                    cell.thumbnailContainer.isHidden = false
                } else {
                    cell.thumbnailContainer.isHidden = true
                }
            }
            cell.titleLabel.isEnabled = true
            cell.previewLabel.isEnabled = true
        } else {
            cell.titleLabel.text = "Error: Could not fetch post"
            cell.previewLabel.text = "There was an error fetching this post. Please refresh and report this incident."
            cell.titleLabel.isEnabled = false
            cell.previewLabel.isEnabled = false
            cell.dateLabel.text = nil
            cell.authorNameLabel.text = nil
            cell.thumbnailContainer.isHidden = true
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
            destination.post = posts[indexPath.row]!
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
            let post = posts[indexPath.row]
            return post != nil
        default:
            return true
        }
    }
 
    @IBAction func refreshView(_ sender: UIRefreshControl) {
        refresh { _ in
            sender.endRefreshing()
        }
    }
    
}
