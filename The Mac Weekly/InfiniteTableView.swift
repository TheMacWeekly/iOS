//
//  InfiniteTableView.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/11/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Result
import enum Siesta.ResourceEvent

func selfDampener<T, U>(_ requests: Observable<T>, converter: @escaping (T) -> U) -> Observable<U.E>
    where U: ObservableConvertibleType {
        var awaitingResponse = false;
        let dampenedRequests = requests.filter({_ in return !awaitingResponse}).do(onNext:{_ in awaitingResponse = true})
        return dampenedRequests.flatMap(converter).do(onNext: {_ in awaitingResponse = false})
}

func pageFetcher<T>(_ requestTriggers: Observable<()>, fetchPage: @escaping (Int) -> Single<Result<T, AnyError>>) -> Observable<T> {
    var page = 1
    
    return selfDampener(requestTriggers, converter: { fetchPage(page) } )
        .do(onNext: { result in
            switch result {
            case .success(_):
                page += 1
            case _:
                break
            }
        }).flatMap({result -> Observable<T> in
            switch result {
            case .success(let data):
                return Observable.just(data)
            case _:
                return Observable.empty()
            }
        })
    
}

class InfiniteTableView<T>: UITableView {
    
    var data: [T] = []
    
    open var fetchPage: ((Int, Int) -> Single<Result<[T], AnyError>>)?
    
    var pageTriggerStream = PublishRelay<()>()
    var pager: Disposable!
    
    open var infiniteScrollMargin = 20
    open var pageLen = 10
    
    func refresh()-> Driver<[T]> {
        pager?.dispose()
        
        data = []
        
        reloadData()
        
        return initPageFetcher()
    }
    
    func initPageFetcher() -> Driver<[T]> {
        let result = pageFetcher(pageTriggerStream.asObservable(), fetchPage: {self.fetchPage!($0, self.pageLen)}).asDriver(onErrorJustReturn: [])
        
        pager = result.drive(onNext: {posts in
            self.data += posts
            self.reloadData()
        })
        pageTriggerStream.accept(())
        return result
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > data.count - infiniteScrollMargin {
            pageTriggerStream.accept(())
        }
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    func dataAt(index: Int) -> T {
        return data[index]
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
