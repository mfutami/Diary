//
//  DiaryWritingViewModel.swift
//  Diary
//
//  Created by futami on 2020/06/13.
//  Copyright © 2020 futami. All rights reserved.
//

import Foundation
typealias SectionType = DiaryWritingViewModel.Section

class DiaryWritingViewModel {
    enum Section {
        case titleHeader([TitleHeader.Title])
        case textHeader([TextHeader.Text])
    }
    
    enum TextStrings: String {
        case cancel = "cancel_text"
        case errorTitle = "error_title"
        case nonCompleted = "nonCompleted_text"
        case ok = "ok_text"
        case title = "title_text"
        case text = "text"
    }
    
    private(set) var section: [Section] = []
    
    private let domain = "https://twitter.com/intent/"
    private let query = "tweet?text="
    
    var title: String?
    var text: String?
    
    init(title: String? = nil, text: String? = nil) {
        self.section = self.setSectionTypes()
        self.title = title
        self.text = text
    }
    
    var urlString: String { self.domain + self.query }
    
    var titleString: String {
        guard let title = TitleCell.textString else { return .empty }
        return "・\(title)\n\n"
    }
    
    private func setSectionTypes() -> [Section] {
        var section: [Section] = []
        section.append(.titleHeader(TitleHeader.items()))
        section.append(.textHeader(TextHeader.items()))
        return section
    }
    
    func textString(_ key: TextStrings) -> String { .LocalizedString(key.rawValue, tableName: "Diary") }
}
