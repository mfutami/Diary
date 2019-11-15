//
//  Strings.swift
//  Diary
//
//  Created by futami on 2019/09/07.
//  Copyright © 2019年 futami. All rights reserved.
//

import Foundation

extension String {
    static func LocalizedString(_ key: String, tableName: String?) -> String {
        if let table = tableName {
            return NSLocalizedString(key, tableName: table, bundle: Bundle.main, value: "", comment: "")
        } else {
            return NSLocalizedString(key, comment: "")
        }
    }
}
