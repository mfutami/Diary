//
//  MemoriesViewModel.swift
//  Diary
//
//  Created by futami on 2020/09/07.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class MemoriesViewModel {
    enum TextStrings: String {
        case error = "error_text"
        case permission = "permission_text"
        case setting = "setting_text"
    }
    
    let settingUrlString = "App-Prefs:root=jp.co.sample.futami.Diary"
    
    func textString(_ key: TextStrings) -> String { .LocalizedString(key.rawValue, tableName: "Memories") }
}
