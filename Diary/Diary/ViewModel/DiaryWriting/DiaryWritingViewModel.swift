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
    
    init() {
        self.section = self.setSectionTypes()
    }
    
    private func setSectionTypes() -> [Section] {
        var section: [Section] = []
        section.append(.titleHeader(TitleHeader.items()))
        section.append(.textHeader(TextHeader.items()))
        return section
    }
}
