//
//  LocationViewModel.swift
//  Diary
//
//  Created by futami on 2019/12/18.
//  Copyright © 2019 futami. All rights reserved.
//

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
}
