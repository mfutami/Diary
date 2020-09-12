//
//  DiaryViewingViewModel.swift
//  Diary
//
//  Created by futami on 2020/06/24.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryViewingViewModel {
    enum Section {
        case title([ViewingTitleHeader.Title])
    }
    private var setSection: [Section] { [.title(ViewingTitleHeader.items())] }
    
    var title: String?
    var text: String?
    var section: [Section] = []
    
    init(title: String? = nil, text: String? = nil) {
        self.section = self.setSection
        self.title = title
        self.text = text
    }
}
