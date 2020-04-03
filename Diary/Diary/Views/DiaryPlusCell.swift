//
//  DiaryPlusCell.swift
//  Diary
//
//  Created by futami on 2020/04/02.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryPlusCell: UITableViewCell {
    static let identifier = "DiaryPlusCell"
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    func setup() {
        self.plusLabel.text = "＋"
        self.plusLabel.font = .systemFont(ofSize: 35)
        self.plusLabel.textColor = .lightGray
        
        self.separatorView.backgroundColor = .lightGray
    }
}
