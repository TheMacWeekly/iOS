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

let API_ROOT = URL(string: "https://themacweekly.com/wp-json/wp/v2/")!

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
    
    func withParam(key: String, value: String?) -> Self {
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

enum PostCategory {
    case all
    case news
    case sports
    case features
    case opinion
    case arts
    case foodAndDrink
    case media
    case home // Not a displayed category
    
    static let order = [
        PostCategory.all,
        PostCategory.news,
        PostCategory.sports,
        PostCategory.features,
        PostCategory.opinion,
        PostCategory.arts,
        PostCategory.foodAndDrink,
        PostCategory.media
    ]
    static let ids: [PostCategory: Int?] = [
        .all: nil,
        .news: 3,
        .sports: 5,
        .features: 4,
        .opinion: 7,
        .arts: 6,
        .foodAndDrink: 28,
        .media: 5292,
        .home: 5271
    ]
    static var categoriesFromIds: [Int: PostCategory] =  {
        var result: [Int: PostCategory] = [:]
        for (key, value) in PostCategory.ids {
            if let v = value {
                result[v] = key
            }
        }
        return result
    }()
    
    var displayName: String? {
        get {
            switch self {
            case .all:
                return "All Posts"
            case .news:
                return "News"
            case .sports:
                return "Sports"
            case .features:
                return "Features"
            case .opinion:
                return "Opinion"
            case .arts:
                return "Arts"
            case .foodAndDrink:
                return "Food & Drink"
            case .media:
                return "Media"
            case .home:
                return nil
            }
        }
    }
    
    var id: Int? {
        get {
            return PostCategory.ids[self]!
        }
    }
    
    static func fromId(_ id: Int) -> PostCategory? {
        return PostCategory.categoriesFromIds[id]
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
            return TestableUtils.collapse(try? JSON.init(data: rawValue).array?.map { post in
                return Post(json: post)
                })
        }
        
        func author(_ authorID: Int, _ type: String) -> Self {
            return self.withParam(key: "filter[meta_key]", value: "_molongui_main_author")
                .withParam(key: "filter[meta_value]", value: "\(type)-\(String(authorID))")
        }
        func page(_ pageNum: Int) -> Self {
            return self.withParam(key: "page", value: String(pageNum))
        }
        func pageLen(_ pageLen: Int) -> Self {
            return self.withParam(key: "per_page", value: String(pageLen))
        }
        func search(_ searchString: String?) -> Self {
            return self.withParam(key: "search", value: searchString == "" ? nil : searchString)
        }
        
        func category(_ category: PostCategory) -> Self {
            if category == PostCategory.all {
                return self.withParam(key: "categories", value: nil)
            }
            return self.category(forID: category.id!)
        }
        func category(forID id: Int) -> Self {
            return self.withParam(key: "categories", value: String(id))
        }
        
    }

}


public struct Author {
    var id: Int
    var name: String
    var bioHTML: String?
    var imgURL: URL?
    var type: String
    
    init?(json:JSON) {
        if let idString = json["id"].string, let name = json["name"].string, let type = json["type"].string {
            guard let id = Int(idString) else {
                return nil
            }
            self.id = id
            self.name = name
            self.type = type

            bioHTML = json["bio"].string

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
    var displayImageURL: URL?
    var link: URL
    var excerptHTML: String
    var categories: [PostCategory] = []
    
    init?(json:JSON) {
        if let id=json["id"].number, let title = json["title"]["rendered"].string, let body = json["content"]["rendered"].string, let timeString = json["date"].string, let linkString = json["link"].string, let excerpt = json["excerpt_plaintext"].string {
            self.id = Int(truncating: id)
            self.title = String.init(htmlEncodedString: title) ?? "" // String extension is located in utils.swift (Testable Utils)
            self.body = body // converting the body of the post results in images not showing up
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
            
            if let displayImageURL = json["full_thumbnail_url"].string {
                self.displayImageURL = URL(string: displayImageURL)
            } else {
                self.displayImageURL = nil
            }
            
            if let categories = json["categories"].array {
                self.categories = categories.flatMap { category in PostCategory.fromId(category.intValue) }
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
        if let url = self.thumbnailURL {
            TestableUtils.getImageFromURLWithCache(key: key, url: url, completion: completion)
        } else {
            completion(nil)
        }
    }
    func displayImage(completion: @escaping  (Image?) -> Void) {
        let key = "displayImage:post-\(self.id)"
        if let url = self.displayImageURL {
            TestableUtils.getImageFromURLWithCache(key: key, url: url, completion: completion)
        } else {
            completion(nil)
        }
    }
}

