//
//  DeleteCell.swift
//  Diary
//
//  Created by futami on 2020/06/13.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DeleteCell: UITableViewCell {
    static let identifier = "DeleteCell"
    
    @IBOutlet weak var deleteButton: UIButton!
    func setup() {
        self.deleteButton.setTitle("削除", for: .normal)
        self.deleteButton.setTitleColor(.white, for: .normal)
        self.deleteButton.titleLabel?.font = .systemFont(ofSize: 20)
        self.deleteButton.backgroundColor = .red
    }
    
}
