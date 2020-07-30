//
//  DiaryViewingViewModel.swift
//  Diary
//
//  Created by futami on 2020/06/24.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryViewingViewModel {
    var title: String?
    var text: String?
    var section: [Section] = []
    
    enum Section {
        case title([ViewingTitleHeader.Title])
    }
    
    init(title: String? = nil, text: String? = nil) {
        self.section = self.setSection()
        self.title = title
        self.text = text
    }
    
    private func setSection() -> [Section] {
        var section: [Section] = []
        section.append(.title(ViewingTitleHeader.items()))
        return section
    }
}
