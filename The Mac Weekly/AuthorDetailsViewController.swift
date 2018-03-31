//
//  AuthorDetailsViewController.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/10/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit

class AuthorDetailsViewController: UIViewController {
    
    var author: Author!
    
    @IBOutlet weak var authorBio: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorProfileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bioHTML = author.bioHTML {
            authorBio.setHTMLFromString(htmlText: bioHTML)
        } else {
            authorBio.isHidden = true
        }
        
        authorName.text = author.name
        if let url = author.imgURL {
            authorProfileImage.kf.setImage(with: url)
            authorProfileImage.clipsToBounds = true
            authorProfileImage.layer.cornerRadius = 8
        } else {
            authorProfileImage.isHidden = true
        }
        
        guard let postsView = self.childViewControllers[0] as? PostTableViewController else {
            fatalError("Child view controller 0 is not the PostTableViewController")
        }
        postsView.infiniteTableView.fetchPage = { (pageNum, pageLen) in
            return TMWAPI.postsAPI.author(self.author.id, self.author.type).page(pageNum).pageLen(pageLen).loadSingle()
        }
        postsView.infiniteTableView.refresh()
        
//        storyboard?.instantiateViewController(withIdentifier: )
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
