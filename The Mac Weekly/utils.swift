//
//  utils.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/6/18.
//  Further modified by Gabriel Brown
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import Foundation
import Result
import Kingfisher

import Firebase
import FirebaseAuth
import GoogleSignIn


// It doesn't seem like this function is being used. Should we just get rid of it?

//func fixShadowImage(inView view: UIView) {
//    if let imageView = view as? UIImageView {
//        let size = imageView.bounds.size.height
//        if size <= 1 && size > 0 &&
//            imageView.subviews.count == 0,
//            let components = imageView.backgroundColor?.cgColor.components, components == [1, 1, 1, 0.15]
//        {
//            print("Fixing shadow image")
//            let forcedBackground = UIView(frame: imageView.bounds)
//            forcedBackground.backgroundColor = .white
//            imageView.addSubview(forcedBackground)
//            forcedBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        }
//    }
//    for subview in view.subviews {
//        fixShadowImage(inView: subview)
//    }
//}

// TODO: At this point should we just rename TestableUtils to Utils? I kinda like TestableUtils because I feel like it's a more descriptive name, but I'm open to either one.

// TODO: Rename this file to match whatever we end up wanting to use



// String extension to fix JSON encoding issue.
// code taken from here, with some modifications for Swift updates: https://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
// converts raw text to proper html format (so that special characters are rendered properly)
// can be accessed from any file
extension String {
    
    init?(htmlEncodedString: String) {
        
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
}


public class TestableUtils {
    
    // Used in conjunction with displaying posts
    // Written by Gabriel Brown
    static func getTimeUnitToUse(timeInterval: TimeInterval) -> NSCalendar.Unit? {
        
        var timeUnit: NSCalendar.Unit
        
        let numSecsInMinute = 60.0
        let numSecsInHour = 3600.0
        let numSecsInDay = 86400.0
        
        // Figure out which time intervals to use. If more than 3 days or negative return as nil (indicates date should be used)
        if timeInterval < 0 {return nil}
        else if timeInterval < (numSecsInDay * 3) {
            
            if timeInterval >= numSecsInDay {
                
                timeUnit = NSCalendar.Unit.day
            } else if timeInterval >= numSecsInHour {
                
                timeUnit = NSCalendar.Unit.hour
            }
            else if timeInterval >= numSecsInMinute {
                
                timeUnit = NSCalendar.Unit.minute
            }
            else {
                
                timeUnit = NSCalendar.Unit.second
            }
            
            return timeUnit
        }
        else {
            return nil
        }
    
    }
    
    // Returns text to be used in the datelabel for posts. If the post was released more than a few days ago, the date style defaults to short
    //
    static func getTextForDateLabel(postDate: Date, dateStyle: DateFormatter.Style = DateFormatter.Style.short) -> String {
        let postTimeInterval = -(postDate.timeIntervalSinceNow)  // Minus sign in front to flip the negative, since everything happened in the past
        
        if let timeUnit = getTimeUnitToUse(timeInterval: postTimeInterval) {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .short
            formatter.includesTimeRemainingPhrase = false
            formatter.allowedUnits = timeUnit
            
            return formatter.string(from: postTimeInterval)! + " ago"
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = dateStyle
            return dateFormatter.string(from: postDate)
        }
        
    }
    
    // Verify that a user's email meets our standards (ie is a mac.edu email)
    static func isMacalesterEmail(email: String) -> Bool {
        
        let pattern = "^[A-Z0-9._%+-]+@macalester.edu$"
        // The "^" and "$" characters indicate the start and end of the string, ensuring that the whole string must fit this pattern
        // ALSO: two slashes are used here instead of one because swift gets weird about regular expressions
        
        let doesMatch = email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
        
        return doesMatch
        
    }
    
    // Log in a user through Firebase
    static func login(email: String, password: String) {
        
        print("About to sign in user")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print(error)
            }
            else {
                print("User signed in")
            }
        }
    }
    
    // Register a new user
    static func register(email: String, password: String) {
        
        // TODO: Replace all print statements with logs once we have that set up
        
        if isMacalesterEmail(email: email) {
            
            // NOTE: this automatically signs in this new user
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                if let error = error {
                    print(error)
                }
                else {
                    // Assuming nothing goes wrong with creating/signing in a new user, send them an email
                    print("New user created, about to send email verification")
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("Verification email sent successfully")
                        }

                    }
                }
            }
        }
            
        else {
            print("Not a valid email")
        }
    }
    
    // Log current user out of firebase and out of their google account
    static func logout() {
        
        // TODO: Replace all print statements with logs once we have that set up
        
        if (Auth.auth().currentUser != nil) {
        
            // Sign out of firebase
            print("About to log out of firebase")
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print(signOutError)
            }
            print("Logged out of Firebase")
            
            // Sign out of Google account (without this user gets locked out of trying another account)
            print("About to log out of Google account")
            GIDSignIn.sharedInstance().signOut()
            print("Logged out of Google account")
            
        }
        else {
            print("No user signed in")
        }
    }
    
    // Check login status without having to import firebase auth
    static func isLoggedIn() -> Bool {
        
        return Auth.auth().currentUser != nil
        
    }

        // TODO: Leave a comment describing the purpose of this function
    static func collapse<T>(_ opt: T??) -> T? {
        switch opt {
        case .none:
            return nil
        case .some(let res):
            return res
        }
    }
    
    static func getImageFromURLWithCache(key: String, url:URL, completion: @escaping  (Image?) -> Void) {
        ImageCache.default.retrieveImage(forKey: key, options: nil) { (img, cacheType) in
            if let img = img {
                completion(img)
                return
            } else {
                ImageDownloader.default.downloadImage(with: url) { (img, error, url, data) in
                    if let img = img {
                        ImageCache.default.store(img, forKey: key)
                        completion(img)
                        return
                    }
                }
            }
            completion(nil)
        }
    }
    

}

