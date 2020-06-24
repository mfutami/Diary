//
//  ViewingTitleHeader.swift
//  Diary
//
//  Created by futami on 2020/06/24.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

struct ViewingTitleHeader {
    enum Title: CaseIterable {
        case text
        
        var identifier: String {
            switch self {
            case .text:
                return ViewingTextCell.identifier
            }
        }
    }
    
    static func items() -> [Title] {
        return [Title.text]
    }
}
