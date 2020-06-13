//
//  DiaryCell.swift
//  Diary
//
//  Created by futami on 2020/06/10.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryCell: UITableViewCell {
    static let identifier = "DiaryCell"

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var diaryButton: UIButton!
    
    func setup() {
        self.backgroundColor = .clear
        
        self.baseView.backgroundColor = .white
        self.baseView.layer.cornerRadius = 10
        // baseView - shadow
        self.baseView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.baseView.layer.shadowColor = UIColor.black.cgColor
        self.baseView.layer.shadowOpacity = 0.2
        self.baseView.layer.shadowRadius = 1
        
        self.diaryButton.setTitle("飲み会", for: .normal)
        self.diaryButton.setTitleColor(.black, for: .normal)
        self.diaryButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.diaryButton.titleEdgeInsets = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: .zero)
    }
    
}
