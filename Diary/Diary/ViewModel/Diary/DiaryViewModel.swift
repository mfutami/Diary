//
//  DiaryViewModel.swift
//  Diary
//
//  Created by futami on 2020/07/23.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryViewModel {
    enum TextStrings: String {
        case operationSelection = "operationSelection_text"
        case browse = "browse_text"
        case edit = "edit_text"
        case delete = "delete_text"
        case back = "back_text"
        case plus = "plus_text"
    }
    var colorCode: UIColor { UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1) }
    
    func textString(_ key: TextStrings) -> String { .LocalizedString(key.rawValue, tableName: "Diary") }
    
    // 時刻取得
    var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
}
