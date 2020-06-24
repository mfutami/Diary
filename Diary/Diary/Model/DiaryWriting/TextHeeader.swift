//
//  TextHeeader.swift
//  Diary
//
//  Created by futami on 2020/06/13.
//  Copyright © 2020 futami. All rights reserved.
//

import Foundation

struct TextHeader {
    enum Text: CaseIterable {
        case text
        case icon
        
        var identifier: String {
            switch self {
            case .text:
                return TextCell.identifier
            case .icon:
                return IconCell.identifier
            }
        }
    }
    
    static func items() -> [Text] {
        var item = [Text]()
        item.append(.text)
        item.append(.icon)
        return item
    }
}
