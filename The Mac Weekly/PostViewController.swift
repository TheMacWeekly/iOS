//
//  PostViewController.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/5/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import WebKit

class PostViewController: UIViewController {
    
    var post: Post?
    
    @IBOutlet weak var postWebView: WKWebView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var webviewHeight: NSLayoutConstraint!
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch (keyPath ?? "") {
        case "contentSize":
            guard let scrollView = object as? UIScrollView else {
                fatalError()
            }
            webviewHeight.constant = scrollView.contentSize.height
        default:
            break
        }
    }
    func prepHTML(_ html: String) -> String {
        return """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
        
                <style>
                    body {
                        font-family: sans-serif;
                        margin-left: 1em;
                        margin-right: 1em;
                    }
                    img {
                        max-width: 100%;
        height: auto;
                    }
        figure {
        margin-left: 0.5em;
        margin-right: 0.5em;
        }
                    figcaption {
                        color: darkgrey;
                        font-size: 12pt;
                        font-weight: lighter;
                    }
        
                    p {
                        font-size: 18pt;
                        line-height: 1.25;
                        margin-bottom: 1em;
                    }
                </style>
            </head>
            <body>
                \(html)
            </body>
        </html>
        """
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = post else {
            fatalError("Requires Post")
        }
        postTitleLabel.text = post.title
        postAuthorLabel.text = post.author != nil ? "By \(post.author!.name)" : nil
        postWebView.loadHTMLString(prepHTML(post.body), baseURL: nil)
        postWebView.scrollView.isScrollEnabled = false
        postWebView.translatesAutoresizingMaskIntoConstraints = false
//        postWebView.
        // Never removed... memory leak?
        postWebView.scrollView.addObserver(self, forKeyPath: "contentSize", context: nil)
        
//        postWebView.scrollView.observe
//        let constraint = NSLayoutConstraint.init(item: postWebView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: postWebView.scrollView.contentSize.height)
        //postWebView.superview?.addConstraint(constraint)
        
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
    
    // MARK: Actions
    @IBAction func showFromPostTable(sender: UIStoryboardSegue) {
        
    }

}
