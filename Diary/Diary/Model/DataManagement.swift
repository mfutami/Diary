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
    func addLocationData(address: String) {
        let locationData = LocationData()
        locationData.streetAddress = address
        
        guard let realm = try? Realm() else { return }
        try? realm.write {
            realm.add(locationData)
        }
    }
}
