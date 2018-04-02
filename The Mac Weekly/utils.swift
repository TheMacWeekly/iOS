//
//  utils.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/6/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import Foundation
import Result
import Kingfisher

let defaultDateFormat = "MM/dd/YY"

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

func collapse<T>(_ opt: T??) -> T? {
    switch opt {
    case .none:
        return nil
    case .some(let res):
        return res
    }
}

func fixShadowImage(inView view: UIView) {
    if let imageView = view as? UIImageView {
        let size = imageView.bounds.size.height
        if size <= 1 && size > 0 &&
            imageView.subviews.count == 0,
            let components = imageView.backgroundColor?.cgColor.components, components == [1, 1, 1, 0.15]
        {
            print("Fixing shadow image")
            let forcedBackground = UIView(frame: imageView.bounds)
            forcedBackground.backgroundColor = .white
            imageView.addSubview(forcedBackground)
            forcedBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    for subview in view.subviews {
        fixShadowImage(inView: subview)
    }
}

func getImageFromURLWithCache(key: String, url:URL, completion: @escaping  (Image?) -> Void) {
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

