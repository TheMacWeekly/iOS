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
    //let pullToRefresh = UIRefreshControl()
    
    var leadPost: Post?

    var infiniteTableView: InfinitePostTableView {
        return self.tableView as! InfinitePostTableView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infiniteTableView.fetchPage = { (pageNum, pageLen) in
            return TMWAPI.postsAPI.page(pageNum).pageLen(pageLen).loadSingle()
        }
        infiniteTableView.addData = { (old, new) in
            var newPosts: [Post?] = new

            if old.count == 0 {
                self.leadPost = nil
                for (idx, post) in new.enumerated() {
                    if post != nil && post!.categories.contains(PostCategory.home) {
                        self.leadPost = post
                        newPosts.remove(at: idx)
                        newPosts = [self.leadPost] + newPosts
                        break
                    }
                }
            }

            return old + newPosts
        }
        infiniteTableView.initPageFetcher()
        
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && leadPost != nil {
            return 250
        } else {
            return 90
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if #available(iOS 10.0, *) {
            //tableView.refreshControl = pullToRefresh
        } else {
            //tableView.addSubview(pullToRefresh)
        }
        //pullToRefresh.addTarget(self, action: #selector(refreshView(_:)), for: .valueChanged)
        let isBigCell = (indexPath.row == 0 && leadPost != nil)
        let identifier = isBigCell ? "PostTableViewCellBig" : "PostTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PostTableViewCell else {
            fatalError("The dequed cell is not an instance of PostTableViewCell.")
        }
        
        if let post = infiniteTableView.dataAt(index: indexPath.row) {
            cell.loadPost(post, shouldUseLargeImage: isBigCell)
        } else {
            cell.loadErrorPost()
        }
        
        return cell
    }
    
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
