//
//  DemoSearchViewController.swift
//  The Mac Weekly
//
//  Created by Mack Hartley on 2/12/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit

class DemoSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let postTableViewController = self.childViewControllers[0] as? PostTableViewController else {
            fatalError("Shouldnt happen")
        }
        
        postTableViewController.infiniteTableView.fetchPage = {(pageNum, pageLen) in
            return TMWAPI.postsAPI.search("knee").page(pageNum).pageLen(pageLen).loadSingle()
        }
        
        postTableViewController.infiniteTableView.refresh()
        

        // Do any additional setup after loading the view.
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
