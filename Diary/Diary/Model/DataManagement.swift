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
}
