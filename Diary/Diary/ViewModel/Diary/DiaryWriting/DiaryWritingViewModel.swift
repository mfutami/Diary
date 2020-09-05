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
    
    private(set) var section: [Section] = []
    
    private let domain = "twitter.com/intent/"
    private let query = "tweet?text="
    
    var title: String?
    var text: String?
    
    init(title: String? = nil, text: String? = nil) {
        self.section = self.setSectionTypes()
        self.title = title
        self.text = text
    }
    
    var urlString: String {
        return "https://" + self.domain + self.query
    }
    
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
}
