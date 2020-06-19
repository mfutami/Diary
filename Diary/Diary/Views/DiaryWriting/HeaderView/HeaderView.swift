//
//  HeaderView.swift
//  Diary
//
//  Created by futami on 2020/06/16.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    private var titleLabel: UILabel!
    
    static let headerHeight: CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setuoSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setuoSubView()
    }
    
    private func setuoSubView() {
        let label = UILabel(frame: frame)
        self.addSubview(label)
        self.titleLabel = label
    }
    
    func setup(text: String) {
        self.backgroundColor = .clear
        
        self.titleLabel.backgroundColor = .white
        self.titleLabel.text = text
        self.titleLabel.textColor = .black
        self.titleLabel.textAlignment = .left
        self.titleLabel.font = .boldSystemFont(ofSize: 20)
    }
}
