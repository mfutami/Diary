//
//  ViewingTitleCell.swift
//  Diary
//
//  Created by futami on 2020/06/24.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class ViewingTextCell: UITableViewCell {
    static let identifier = "ViewingTextCell"
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var viewingTextLabel: UILabel!
    
    func setup(text: String?) {
        self.baseView.backgroundColor = .white
        
        self.viewingTextLabel.text = text
        self.viewingTextLabel.font = .systemFont(ofSize: 20)
        self.viewingTextLabel.textColor = .black
        self.viewingTextLabel.textAlignment = .left
        self.viewingTextLabel.numberOfLines = .zero
    }
}
