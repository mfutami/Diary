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
    private let url = "https://toyokeizai.net/list/feed/rss"
    
    func xmlPaserRxSwift() -> Observable<Data> {
        return Observable.create { observer in
            if let apiUrl = URL(string: self.url) {
                let task = URLSession(configuration: .default)
                    .dataTask(with: URLRequest(url: apiUrl)) { date, response, error in
                    guard let date = date else { return }
                    observer.onNext(date)
                }
                task.resume()
            }
            return Disposables.create()
        }
    }
}
