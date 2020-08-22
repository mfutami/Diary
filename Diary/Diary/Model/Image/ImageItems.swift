//
//  ImageItems.swift
//  Diary
//
//  Created by futami on 2019/11/05.
//  Copyright © 2019年 futami. All rights reserved.
//
import UIKit

struct ImageItems {
    static func getImageByUrl(url: String, completion: ((UIImage?) -> Void)? = nil) {
        DispatchQueue.global().async {
            guard let url = URL(string: url) else { return }
            do {
                let data = try Data(contentsOf: url)
                completion?(UIImage(data: data))
            } catch {
                completion?(UIImage(named: "error"))
            }
        }
    }
}
