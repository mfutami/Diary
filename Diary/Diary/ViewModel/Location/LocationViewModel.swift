//
//  LocationViewModel.swift
//  Diary
//
//  Created by futami on 2019/12/18.
//  Copyright © 2019 futami. All rights reserved.
//
import UIKit

class LocationViewModel {
    enum TextStrings: String {
        case record = "record_title"
        case noneData = "noneData_text"
        case errorTitle = "errorDialogTitle"
        case errorText = "errorDialogMessage"
        case ok = "ok"
        case cancel = "cancel"
        case deleteTitle = "delete_title"
        case cannotBeRestored = "cannotBeRestored_text"
        case yesText = "yes_text"
        case noText = "no_text"
        case locationNone = "locationNone_text"
        case again = "again_text"
    }
    
    private var registration: [String]?
    
    func textString(_ key: TextStrings) -> String { .LocalizedString(key.rawValue, tableName: "Location") }
    
    static var registrationData: String? {
        get { UserDefaults.standard.string(forKey: "registrationData") }
        set { UserDefaults.standard.set(newValue, forKey: "registrationData") }
    }
    
    var registrationPoint: [String]? {
        get { UserDefaults.standard.array(forKey: "registrationPoint") as? [String] ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: "registrationPoint") }
    }
    
    var backgroundColor: UIColor { UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0) }
    
    var alreadyRegistered: Bool { UserDefaults.standard.bool(forKey: "register") }
    
    func deleteRegistrationPoint() { UserDefaults.standard.removeObject(forKey: "registrationPoint") }
    
    func whetherToRegister() { UserDefaults.standard.set(true, forKey: "register") }
}
