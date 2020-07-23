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
        return NSLocalizedString(key,
                                 tableName: tableName,
                                 comment: "")
    }
}
