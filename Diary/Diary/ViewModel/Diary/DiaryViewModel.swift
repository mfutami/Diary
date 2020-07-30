//
//  DiaryViewModel.swift
//  Diary
//
//  Created by futami on 2020/07/23.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryViewModel {
    // 時刻取得
    var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var colorCode: UIColor {
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }
}
