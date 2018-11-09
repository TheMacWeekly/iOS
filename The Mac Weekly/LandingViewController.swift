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
    
    
    
    
    // MARK: Properties
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
        
        self.definesPresentationContext = true  // Ensures search bar doesn't disappear after viewing article
        
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
    
    // This happens right before the page is navigated away from
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //TODO: cache articles here so we don't have to reload them every time we go back?
        
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
    
    // MARK: Navigating to settings
    
    @IBAction func goToSettings(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    
    

}
