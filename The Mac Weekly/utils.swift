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


// Source: https://stackoverflow.com/a/30711288
extension UILabel {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>" as NSString, htmlText) as String
        
        //process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
        self.attributedText = attrStr
    }
}

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

