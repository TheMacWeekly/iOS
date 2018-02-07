//
//  api.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/3/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher



public struct Author {
    var id: Int
    var name: String
    var imgURL: URL?
    
    init?(json:JSON) {
        if let idString = json["id"].string, let name = json["name"].string {
            guard let id = Int(idString) else {
                return nil
            }
            self.id = id
            self.name = name
            if let imgURLString = json["img_url"].string {
                imgURL = URL(string: imgURLString)
            } else {
                imgURL = nil
            }
        } else {
            return nil
        }
        
    }
}

public struct Post {
    var id: Int
    var author: Author?
    var title: String
    var body: String
    var time: Date
    var thumbnailURL: URL?
    var link: URL
    var excerpt: String
    
    init?(json:JSON) {
        if let id=json["id"].number, let title = json["title"]["rendered"].string, let body = json["content"]["rendered"].string, let timeString = json["date"].string, let linkString = json["link"].string, let excerpt = json["excerpt_plaintext"].string {
            self.id = Int(truncating: id)
            self.title = title
            self.body = body
            self.excerpt = excerpt
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            guard let time = formatter.date(from: timeString) else {
                return nil
            }
            self.time = time
            
            self.author = Author(json: json["guest_author"])
            
            if let thumbnailURL = json["normal_thumbnail_url"].string {
                self.thumbnailURL = URL(string: thumbnailURL)
            } else {
                self.thumbnailURL = nil
            }
            
            guard let link = URL(string: linkString) else {
                fatalError("Could not parse post link")
            }
            self.link = link
            
        } else {
            return nil
        }
    }
    func thumbnail(completion: @escaping  (Image?) -> Void) {
        let key = "thumbnail:post-\(self.id)"
        ImageCache.default.retrieveImage(forKey: key, options: nil) { (thumbnail, cacheType) in
            if let thumbnail = thumbnail {
                completion(thumbnail)
                return
            } else if let thumbnailURL = self.thumbnailURL {
                ImageDownloader.default.downloadImage(with: thumbnailURL) { (thumbnail, error, url, data) in
                    if let thumbnail = thumbnail {
                        ImageCache.default.store(thumbnail, forKey: key)
                        completion(thumbnail)
                        return
                    }
                }
            }
            completion(nil)
        }
    }
}
let API_ROOT = URL(string: "http://themacweekly.com/wp-json/wp/v2/")!

public func getPosts(_ page: Int = 1, completion: @escaping ([Post?]) -> Void) -> DataRequest {
    var url = URLComponents(string: "posts")
    url?.queryItems = [URLQueryItem(name: "page", value: String(page))]
    return Alamofire.request(url!.url(relativeTo: API_ROOT)!).responseJSON { response in
        if let json = response.result.value {
            completion(JSON(json).array?.map { postJSON in
                // Simulate errors
                if Double(arc4random())/Double(Int32.max) < 0.25 {
                    return nil
                }
                return Post(json: postJSON)
            } ?? [])
            
        } else {
            completion([])
        }
    }
}

public func getPost(postID: Int,  completion: @escaping (Post?) -> Void ) -> DataRequest {
    return Alamofire.request(API_ROOT.appendingPathComponent("posts/\(postID)")).responseJSON { response in
        if let json = response.result.value {
            completion(Post.init(json: JSON.init(json)))
        } else {
            completion(nil)
        }
    }
}

