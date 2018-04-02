//
//  LandingViewController.swift
//  The Mac Weekly
//
//  Created by Hunter Herman on 4/1/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit

extension CALayer {
    var shadowUIColor: UIColor? {
        get {
            if shadowColor != nil {
                return UIColor(cgColor: shadowColor!)
            } else {
                return nil
            }
        }
        set(uiColor) {
            shadowColor = uiColor?.cgColor
        }
    }

}

class LandingViewController: UIViewController, UISearchResultsUpdating {
    
    
    
    

    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoryView: UIStackView!
    @IBOutlet weak var postView: UIView!
    var postTableView: PostTableViewController!
    
    var selectedButton: UIButton!
    var searchController: UISearchController!
    
    var curPostsAPI: TMWAPI.PostsAPI!

    func refresh() {
        postTableView.infiniteTableView.refresh()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curPostsAPI = TMWAPI.postsAPI
        postTableView.infiniteTableView.fetchPage = {(pageNum, pageLen) in
            return self.curPostsAPI.page(pageNum).pageLen(pageLen).loadSingle()
        }
        
        do {
            navigationController?.view.backgroundColor = UIColor.white
            navigationController!.navigationBar.isTranslucent = false
            navigationController!.navigationBar.shadowImage = UIImage()
            navigationItem.largeTitleDisplayMode = .never
        }
        
        do {
            navigationController?.navigationBar.isTranslucent = false
            
            searchController = UISearchController(searchResultsController: nil)
            
            searchController.dimsBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
            
            searchController.searchResultsUpdater = self
            navigationItem.searchController = searchController
//            navigationItem.searchController.shado
            searchController.isActive = true
            navigationItem.hidesSearchBarWhenScrolling = true
            extendedLayoutIncludesOpaqueBars = true
            postTableView.refreshControl = nil
        }

                
        categoriesScrollView.canCancelContentTouches = true
        
        PostCategory.order.enumerated().forEach {(idx, cat) in
            
            var button = UIButton(type: UIButtonType.system)
            
            if cat == PostCategory.all {
                selectedButton = button
                selectedButton.isSelected = true
            }
            
            
            button.setTitle(cat.displayName, for: .normal)
            button.tag = idx
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: UIControlEvents.touchUpInside)
            
            categoryView.addArrangedSubview(button)
            
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func buttonAction(sender: UIButton!) {
        selectedButton.isSelected = false
        selectedButton = sender
        selectedButton.isSelected = true
        
        let cat = PostCategory.order[sender.tag]
        
        curPostsAPI = curPostsAPI.category(cat)
        refresh()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.shadowImage = UIImage()

        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let view as PostTableViewController:
            postTableView = view
        default:
            break
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        curPostsAPI = curPostsAPI.search(searchController.searchBar.text)
        
        refresh()
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
