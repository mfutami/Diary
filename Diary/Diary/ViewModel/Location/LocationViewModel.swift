//
//  LocationViewModel.swift
//  Diary
//
//  Created by futami on 2019/12/18.
//  Copyright © 2019 futami. All rights reserved.
//
import UIKit

class LocationViewModel {
    static var registrationData: String? {
        get {
            UserDefaults.standard.string(forKey: "registrationData")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "registrationData")
        }
    }
    
    var registrationPoint: [String]? {
        get {
            UserDefaults.standard.array(forKey: "registrationPoint") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "registrationPoint")
        }
    }
    
    func deleteRegistrationPoint() {
        UserDefaults.standard.removeObject(forKey: "registrationPoint")
    }
    
    private var registration: [String]?
    
    var errorDialogTitle: String {
        return String.LocalizedString("errorDialogTitle", tableName: "Location")
    }
    var errorDialogMessage: String {
        return String.LocalizedString("errorDialogMessage", tableName: "Location")
    }
    var okButtonTitle: String {
        return String.LocalizedString("ok", tableName: "Location")
    }
    var cancelButtonTitle: String {
        return String.LocalizedString("cancel", tableName: "Location")
    }
    var recordButtonTitle: String {
        return String.LocalizedString("record_title", tableName: "Location")
    }
    var backgroundColor: UIColor {
        return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
    }
    
    var alreadyRegistered: Bool {
        UserDefaults.standard.bool(forKey: "register")
    }
    
    func whetherToRegister() {
        UserDefaults.standard.set(true, forKey: "register")
    }
}
