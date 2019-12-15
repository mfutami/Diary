//
//  NewsViewModel.swift
//  Diary
//
//  Created by futami on 2019/11/03.
//  Copyright © 2019年 futami. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SWXMLHash

class NewsViewModel {
    private let url = URL(string: "https://toyokeizai.net/list/feed/rss")
    
    //    func urlSession(completion: ((Data?) -> Void)? = nil) {
    //        guard let apiUrl = self.url else { return }
    //        let urlRequest = URLRequest(url: apiUrl)
    //        let configuration = URLSessionConfiguration.default
    //        let session = URLSession(configuration: configuration)
    //        _ = session.dataTask(with: urlRequest) { date, response, error in
    //            completion?(date)
    //        }
    //    }
    
    func xmlPaserRxSwift() -> Observable<Data> {
        return Observable.create { observer in
            if let apiUrl = self.url {
                let urlRequest = URLRequest(url: apiUrl)
                let configuration = URLSessionConfiguration.default
                let session = URLSession(configuration: configuration)
                let task = session.dataTask(with: urlRequest) { date, response, error in
                    guard let date = date else { return }
                    observer.onNext(date)
                }
                task.resume()
            }
            return Disposables.create()
        }
    }
}
