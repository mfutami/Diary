//
//  image.swift
//  Diary
//
//  Created by futami on 2019/11/05.
//  Copyright © 2019年 futami. All rights reserved.
//
import UIKit

extension UIImage {
    static func getImageByUrl(url: String) -> UIImage? {
        guard let url = URL(string: url) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            
        }
        return nil
    }
}
