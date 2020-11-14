//
//  FileManager.swift
//  Diary
//
//  Created by futami on 2020/09/17.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit
import Foundation

struct FileManagerApp {
    // TODO: ちゃんと読み込めない。。。
    static func saveFile(imageData: Data) {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[.zero]
        do {
            try imageData.write(to: documentPath)
        } catch {
            return
        }
    }
    
    static func fileDownloader(imageString: String) -> URL? {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[.zero]
        return documentPath.appendingPathComponent(imageString)
    }
    
    static func setupDirectly() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[.zero]
        let directoryName = "News"
        let createPath = documentsPath + "/" + directoryName

        do {
            try FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return
        }
    }
    
    static func remove(_ pathName: String) -> Bool {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[.zero]
        do {
            try FileManager.default.removeItem(atPath: documentsPath + "/" + "News")
        } catch {
            return false
        }
        return true
    }
    
    static var cachesDirectoryUrl: URL? {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        if let url = urls.first {
            return url
        } else {
            return nil
        }
    }
}
