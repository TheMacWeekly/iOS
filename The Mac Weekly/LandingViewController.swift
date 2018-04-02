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

class LandingViewController: UIViewController {

    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoryView: UIStackView!
    @IBOutlet weak var postView: UIView!
    var postTableView: PostTableViewController!
    
    var selectedButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            navigationController!.navigationBar.isTranslucent = false
            
            // The navigation bar's shadowImage is set to a transparent image.  In
            // addition to providing a custom background image, this removes
            // the grey hairline at the bottom of the navigation bar.  The
            // ExtendedNavBarView will draw its own hairline.
            navigationController!.navigationBar.shadowImage = UIImage()
            
//            let layer = categoriesScrollView.layer
//            // Use the layer shadow to draw a one pixel hairline under this view.
//            layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
//            layer.shadowRadius = 0
//
//            // UINavigationBar's hairline is adaptive, its properties change with
//            // the contents it overlies.  You may need to experiment with these
//            // values to best match your content.
//            layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//            layer.shadowOpacity = 0.25
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
        postTableView.infiniteTableView.fetchPage = { (pageNum, pageLen) in
            return TMWAPI.postsAPI.page(pageNum).pageLen(pageLen).category(cat).loadSingle()
        }
        postTableView.infiniteTableView.refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.shadowImage = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let view as PostTableViewController:
            postTableView = view
        default:
            break
        }
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
