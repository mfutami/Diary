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
    
    func removeLocationData() {
        self.streetAddressData = []
        self.distanceData = []
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
