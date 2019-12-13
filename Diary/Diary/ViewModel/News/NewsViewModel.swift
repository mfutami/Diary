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

class NewsViewModel {
    private let url = URL(string: "https://toyokeizai.net/list/feed/rss")
    
    func urlSession(completion: ((Data?) -> Void)? = nil) {
        guard let apiUrl = self.url else { return }
        let urlRequest = URLRequest(url: apiUrl)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        _ = session.dataTask(with: urlRequest) { date, response, error in
            completion?(date)
        }
    }
    
    func xmlPaserRxSwift() -> Observable<Data> {
        return Observable.create { observer in
            self.urlSession { [weak self] (date) in
                guard let wself = self else { return }
                guard let date = date else { return }
                let xml = SWXMLHash.parse(date)
                for xmls in xml["rss"]["channel"]["item"].all {
                    guard let title = xmls["title"].element?.text,
                        let link = xmls["link"].element?.text,
                        let image = xmls["enclosure"].element?.attribute(by: "url")?.text else { return }
                    self.newsTitle.append(title)
                    self.newsLink.append(link)
                    self.newsImage.append(image)
                }
            }
            return Disposables.create()
        }
    }
}
