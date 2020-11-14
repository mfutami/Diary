//
//  ImageItems.swift
//  Diary
//
//  Created by futami on 2019/11/05.
//  Copyright © 2019年 futami. All rights reserved.
//
import UIKit

struct ImageItems {
    static func getData(_ url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func downloadImage(url: URL?, completion: ((UIImage?) -> Void)? = nil) {
        guard let url = url else { return }
        self.getData(url) { data, response, error in
            guard let data = data, error == nil else { completion?(nil); return }
            self.save(image: UIImage(data: data), fileName: "file.png")
            completion?(UIImage(data: data))
        }
    }
    // TODO: 読み込めたとしてもファイル名が異なるはずだからどう比較するか検討
    static func getImageByUrl(urlString: String, completion: ((UIImage?) -> Void)? = nil) {
        if let data = self.loadImage(fileName: urlString) {
            completion?(data)
            return
        }
        self.downloadImage(url: URL(string: urlString)) { image in
            if let fileData = FileManagerApp.fileDownloader(imageString: urlString) {
                completion?(image)
            } else {
                completion?(UIImage(named: "error"))
            }
        }
    }
    
    
    
     static func save(image: UIImage?, fileName: String) {
         if let data = image?.pngData() {
             self.save(data: data, fileName: fileName)
         } else if let data = image?.jpegData(compressionQuality: 0.8) {
             self.save(data: data, fileName: fileName)
         }
     }
     
     static func save(data: Data, fileName: String) {
         guard let directoryUrl = FileManagerApp.fileDownloader(imageString: fileName) else { return }
         let fileUrl = directoryUrl.appendingPathComponent(fileName)
         do {
             try data.write(to: fileUrl)
         } catch {
            
         }
     }
     
     static func loadImage(fileName: String) -> UIImage? {
         if let data = self.loadData(fileName: fileName) {
             return UIImage(data: data)
         } else {
             return nil
         }
     }

     static func loadData(fileName: String) -> Data? {
        guard let directoryUrl = FileManagerApp.fileDownloader(imageString: fileName) else { return nil }
         let fileUrl = directoryUrl.appendingPathComponent(fileName)
         do {
             return try Data(contentsOf: fileUrl)
         } catch {
             return nil
         }
     }

    private static func cachedImagesDirectoryUrl() -> URL? {
         guard let url = self.directoryUrl else { return nil }
         if FileManager.default.fileExists(atPath: url.absoluteString) { return url }
         do {
             try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
             return url
         } catch {
             return nil
         }
     }

    private static var directoryUrl: URL? {
         return FileManagerApp.cachesDirectoryUrl
     }
}
