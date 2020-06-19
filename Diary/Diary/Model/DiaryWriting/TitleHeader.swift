//
//  TitleHeader.swift
//  Diary
//
//  Created by futami on 2020/06/13.
//  Copyright © 2020 futami. All rights reserved.
//

import Foundation

struct TitleHeader {
    enum Title {
        case tetle
        
        var identifier: String {
            switch self {
            case .tetle:
                return TitleCell.identifier
            }
        }
    }
    
    static func items() -> [Title] {
        var item = [Title]()
        item.append(.tetle)
        return item
    }
}
