//
//  UILabel+HTML.swift
//  The Mac Weekly
//
//  Created by Gabriel Brown on 8/1/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import Foundation
import UIKit

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

