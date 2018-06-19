//
//  PostViewController.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/5/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import WebKit

class PostViewController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate {
    
    var post: Post?
    
    @IBOutlet weak var postWebView: WKWebView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postAuthorImage: UIImageView!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var webviewHeight: NSLayoutConstraint!
    @IBOutlet weak var authorTopButton: UIButton!
    
    @IBAction func sharePost(_ sender: Any) {
        guard let post = post else {
            fatalError("Should not be clickable without loaded post")
        }
        let shareActivity = UIActivityViewController.init(activityItems: ["OMG!!! Read \"\(post.title)\" on The Mac Weekly.", post.link], applicationActivities: nil)
        present(shareActivity, animated: true)
    }
    
    //open article links in safari
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
            decisionHandler(.cancel)
            UIApplication.shared.open(url)
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    //disable pinch to zoom for webview
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    // resize webview based on content size
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
    // styling for post content
    func prepHTML(_ html: String) -> String {
        return """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
        
                <style>
                    body {
                        font-family: sans-serif;
                        margin:0;
                    }
                    img {
                        max-width: 100%;
        height: auto;
        margin-top: 0.5em;
        margin-bottom: 0.5em;
                    }
        figure {
        margin-left: 0.5em;
        margin-right: 0.5em;
        }
        
        iframe { width:100% } 
        
                    figcaption {
                        color: grey;
                        font-size: 10pt;
                        font-weight: lighter;
                    }
        
                    p {
                        font-size: 12pt;
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
//        navigationController?.hidesBarsOnSwipe = true
        guard let post = post else {
            fatalError("Requires Post")
        }
        postTitleLabel.text = post.title
        
        // Format the date nicely - Gabriel Brown
        postDateLabel.text = TestableUtils.getTextForDateLabel(postDate: post.time, dateStyle: .long)
        
        if let author = post.author {
            authorTopButton.setTitle(author.name, for: .normal)
            authorTopButton.isHidden = false
            postAuthorLabel.text = author.name
            postAuthorLabel.isHidden = false
            if let imgURL = author.imgURL {
                postAuthorImage.layer.cornerRadius = postAuthorImage.bounds.width / 2
                postAuthorImage.kf.setImage(with: imgURL)
            } else {
                postAuthorImage.isHidden = true
            }
        } else {
            authorTopButton.isHidden = true
            postAuthorImage.isHidden = true
            postAuthorLabel.isHidden = true
        }
        
        postWebView.loadHTMLString(prepHTML(post.body), baseURL: nil)
        postWebView.scrollView.isScrollEnabled = false
        postWebView.translatesAutoresizingMaskIntoConstraints = false
        // Never removed... memory leak?
        postWebView.scrollView.addObserver(self, forKeyPath: "contentSize", context: nil)
        postWebView.scrollView.delegate = self
        postWebView.navigationDelegate = self
//        postWebView.scrollView.observe
//        let constraint = NSLayoutConstraint.init(item: postWebView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: postWebView.scrollView.contentSize.height)
        //postWebView.superview?.addConstraint(constraint)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowAuthor":
            guard let author = post?.author else {
                fatalError()
            }
            guard let destination = segue.destination as? AuthorDetailsViewController else {
                fatalError()
            }
            destination.author = author
        default:
            break
        }
        
        
    }
    
    @IBAction func authorBottomButtonEvent(_ sender: UIButton) {
        if sender.isHighlighted {
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        } else {
            sender.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: Actions
    

}
