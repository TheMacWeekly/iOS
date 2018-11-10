//
//  AboutViewController.swift
//  The Mac Weekly
//
//  Created by Gabriel Brown on 10/9/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import Crashlytics

class AboutViewController: UIViewController {
    
    var numTaps: Int = 0
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = "Version " + (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        logo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoTapped(sender:))))
    }
    
    // Manually crash the app to test Crashlytics
    @objc func logoTapped(sender: UITapGestureRecognizer) {
        
        numTaps += 1
        
        if (numTaps == 5) {
            print("\n==============================================\nManual crash, for testing firebase crashlytics\n==============================================\n")
            Crashlytics.sharedInstance().crash()
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
