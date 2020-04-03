//
//  DiaryViewModel.swift
//  Diary
//
//  Created by futami on 2020/04/02.
//  Copyright © 2020 futami. All rights reserved.
//

typealias CellType = DiaryViewModel.CellTypeKey

class DiaryViewModel {
    var displayCellType = [String]()
    enum CellTypeKey: CaseIterable {
        case pulus
        
        var identifier: String? {
            switch self {
            case .pulus:
                return DiaryPlusCell.identifier
            }
        }
    }
    
    func setupCellType() {
        var itmes = [String]()
        itmes.append(DiaryPlusCell.identifier)
        self.displayCellType = itmes
    }
}
