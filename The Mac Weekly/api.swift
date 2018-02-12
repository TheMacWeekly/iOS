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
import RxSwift
import enum Result.Result
import struct Result.AnyError
import Siesta

let API_ROOT = URL(string: "http://themacweekly.com/wp-json/wp/v2/")!

enum APIError : Error {
    case parsingError(description: String)
}

protocol RxAPI {
    associatedtype DataType
    
    static var path: String { get }
    var resource: Siesta.Resource { get set }
    
//    init()
    init(asResource resource: Siesta.Resource)
    
    func parseRawValue(rawValue: Any) -> DataType?
}

extension RxAPI {
    init(_ service: Service) {
        self.init(asResource:service.resource(Self.path))
    }
    
    func withParam(key: String, value: String) -> Self {
        return Self.init(asResource: self.resource.withParam(key, value))
    }
    
    func asObservable() -> Observable<ResourceEvent> {
        return Observable.create { observer in
            self.resource.addObserver(owner: self as AnyObject, closure: {
                resource, event in
                
                observer.onNext(event)
            })
            return Disposables.create()
        }
    }
    func dataObservable() -> Observable<DataType> {
        return asObservable().flatMap { event -> Observable<DataType> in
            switch event {
            case ResourceEvent.newData(let dataSource):
                if let value = self.parseRawValue(rawValue: dataSource.rawValue) {
                    return Observable.just(value)
                } else {
                    return Observable.empty()
                }
            case _:
                return Observable.empty()
            }
        }
    }
    func loadSingle() -> Single<Result<DataType, AnyError>> {
        return Single.create { single in
            let request = self.resource.load()
            request.onFailure { error in
                single(.success(Result.failure(AnyError.error(from: error))))
            }
            request.onSuccess { result in
                
                if let data = self.parseRawValue(rawValue: result.content) {
                    single(.success(Result.success(data)))
                } else {
                    single(.success(Result.failure(AnyError.error(from: APIError.parsingError(description: "Could not parse data")))))
                }
            }
            return Disposables.create()
        }
    }
    func loadIfNeeded() -> Siesta.Request? {
        return resource.loadIfNeeded()
    }
}


class TMWAPI {

    static let service = Service(baseURL: API_ROOT, standardTransformers: [])
    static let postsAPI = PostsAPI.init(service)
    
    class PostsAPI: RxAPI {
        static var path: String {
            return "posts"
        }
        
        var resource: Siesta.Resource
        
        // This is so stupid... can't figure out how to get rid of it
        required init(asResource resource: Siesta.Resource) {
            self.resource = resource
        }
        
        typealias DataType = [Post?]
        func parseRawValue(rawValue: Any) -> [Post?]? {
            guard let rawValue = rawValue as? Data else {
                return nil
            }
            return collapse(try? JSON.init(data: rawValue).array?.map { post in
                return Post(json: post)
                })
        }
        
        func author(_ authorID: Int) -> Self {
            return self.withParam(key: "filter[meta_key]", value: "_molongui_guest_author_id")
                .withParam(key: "filter[meta_value]", value: String(authorID))
        }
        func page(_ pageNum: Int) -> Self {
            return self.withParam(key: "page", value: String(pageNum))
        }
        func pageLen(_ pageLen: Int) -> Self {
            return self.withParam(key: "per_page", value: String(pageLen))
        }
        
    }

}


public struct Author {
    var id: Int
    var name: String
    var bioHTML: String?
    var imgURL: URL?
    
    init?(json:JSON) {
        if let idString = json["id"].string, let name = json["name"].string {
            guard let id = Int(idString) else {
                return nil
            }
            self.id = id
            self.name = name
            
            if let bioHTML = json["bio"].string {
                self.bioHTML = bioHTML
            } else {
                self.bioHTML = nil
            }
            
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
    var excerptHTML: String
    
    init?(json:JSON) {
        if let id=json["id"].number, let title = json["title"]["rendered"].string, let body = json["content"]["rendered"].string, let timeString = json["date"].string, let linkString = json["link"].string, let excerpt = json["excerpt_plaintext"].string {
            self.id = Int(truncating: id)
            self.title = title
            self.body = body
            self.excerptHTML = excerpt
            
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

