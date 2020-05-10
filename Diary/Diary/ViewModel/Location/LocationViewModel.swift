//
//  LocationViewModel.swift
//  Diary
//
//  Created by futami on 2019/12/18.
//  Copyright © 2019 futami. All rights reserved.
//
import UIKit

class LocationViewModel {
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
}
