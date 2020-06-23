//
//  DataManagement.swift
//  Diary
//
//  Created by futami on 2020/05/10.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit
import RealmSwift

class DataManagement {
    
    var streetAddressData = [String]()
    var distanceData = [String]()
    
    var photoImageArreData = [Data]()
    
    var diaryDate = [String: Any]()
    
    // 現在位置情報保存
    func addLocationData(address: String?, distance: String) {
        guard let address = address else { return }
        let realm = try! Realm()
        let locationData = LocationData()
        locationData.streetAddress = address
        locationData.distance = distance
        try! realm.write {
            realm.add(locationData)
        }
    }
    
    func addDate() {
        let realm = try! Realm()
        let dateArray: [String: Any] = ["date": DiaryViewController.date ?? "",
                                        "list": [["title": TitleCell.textString ?? "",
                                                 "text": TextCell.textViewString ?? ""]]]
        print(dateArray)
        self.diaryDate = dateArray
        let date = DiaryDate(value: dateArray)
        try! realm.write {
            realm.add(date)
        }
    }
    
    // フォトイメージ保存
    func addPhotoImage(data: Data) {
        let realm = try! Realm()
        let photoImageData = PhotoImageData()
        photoImageData.photoImage = data
        try! realm.write {
            realm.add(photoImageData)
        }
    }
    
    func readInformation() {
        // データの初期化
        self.streetAddressData = []
        self.distanceData = []
        let realm = try! Realm()
        let locationData = realm.objects(LocationData.self)
        locationData.forEach {
            self.streetAddressData.append($0.streetAddress)
            self.distanceData.append($0.distance)
        }
    }
    
    func readPhotoImage() {
        self.photoImageArreData = []
        let realm = try! Realm()
        let photoImageData = realm.objects(PhotoImageData.self)
        photoImageData.forEach {
            self.photoImageArreData.append($0.photoImage)
        }
    }
    
    func getdate() {
        DiaryViewController.title = []
        DiaryViewController.text = []
        let realm = try! Realm()
        let diaryDate = realm.objects(DiaryDate.self)
        try! realm.write {
            diaryDate.forEach {
                if $0.date == DiaryViewController.date {
                    for date in $0.list {
                        DiaryViewController.title.append(date.title)
                        DiaryViewController.text.append(date.text)
                    }
                }
            }
        }
    }
    
    func removeLocationData() {
        self.streetAddressData = []
        self.distanceData = []
        let realm = try! Realm()
        let locationData = realm.objects(LocationData.self)
        try! realm.write {
            realm.delete(locationData)
        }
    }
    
    func removePhotoImage() {
        self.photoImageArreData = []
        let realm = try! Realm()
        let photoImageData = realm.objects(PhotoImageData.self)
        try! realm.write {
            realm.delete(photoImageData)
        }
    }
    
    func removeDate() {
        let realm = try! Realm()
        let diaryDate = realm.objects(DiaryDate.self)
        try! realm.write {
            diaryDate.forEach {
                for (index, _) in $0.list.enumerated() {
                    if $0.date == DiaryViewController.date {
                        realm.delete($0)
                        DiaryViewController.title.remove(at: index)
                        DiaryViewController.text.remove(at: index)
                    }
                }
            }
        }
    }
}
