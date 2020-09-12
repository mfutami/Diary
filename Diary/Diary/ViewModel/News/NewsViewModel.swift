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
    enum TextStrings: String {
        case communicationError = "communicationError_text"
        case again = "again_text"
        case reacquire = "reacquire_text"
    }
    
    private let url = "https://toyokeizai.net/list/feed/rss"
    
    func textString(_ key: TextStrings) -> String { .LocalizedString(key.rawValue, tableName: "News") }
    
    func newsInfoAcquisitionProcess() -> Observable<Data> {
        return Observable.create { observer in
            if let apiUrl = URL(string: self.url) {
                let task = URLSession(configuration: .default)
                    .dataTask(with: URLRequest(url: apiUrl)) { date, response, error in
                        if let error = error {
                            observer.onError(error)
                            return
                        }
                        if let date = date { observer.onNext(date) }
                }
                task.resume()
            }
            return Disposables.create()
        }
    }
}
