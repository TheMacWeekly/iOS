//
//  PostSearchViewController.swift
//  The Mac Weekly
//
//  Created by Hunter Herman on 3/31/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit

class PostSearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var postSearchView: UIView!
    
    var postTableView: PostTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let view as PostTableViewController:
            postTableView = view
        default:
            break
        }
    }
    
    func search(_ text: String) {
        postTableView.infiniteTableView.fetchPage = { (pageNum, pageLen) in
            return TMWAPI.postsAPI.page(pageNum).pageLen(pageLen).search(text).loadSingle()
        }
        postTableView.infiniteTableView.refresh()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            search(text)
            searchBar.resignFirstResponder()
        }
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
