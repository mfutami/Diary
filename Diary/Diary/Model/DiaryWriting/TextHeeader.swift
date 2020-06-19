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
        case delete
        case icon
        
        var identifier: String {
            switch self {
            case .text:
                return TextCell.identifier
            case .delete:
                return DeleteCell.identifier
            case .icon:
                return IconCell.identifier
            }
        }
    }
    
    static func items() -> [Text] {
        var item = [Text]()
        item.append(.text)
        // TODO: deleteは編集ボタン押下時のみ表示するので後日
//        item.append(.delete)
        item.append(.icon)
        return item
    }
}
