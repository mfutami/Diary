//
//  ViewingTitleHeaderView.swift
//  Diary
//
//  Created by futami on 2020/06/25.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class ViewingTitleHeaderView: UIView {
    
    private var titleLabel: UILabel!
    private var leftView: UIView!
    
    static let height: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubViews()
    }
    
    private func setupSubViews() {
        let view = UIView(frame: CGRect(x: self.frame.origin.x,
                                        y: self.frame.origin.y,
                                        width: 5,
                                        height: self.frame.height))
        self.addSubview(view)
        self.leftView = view
        
        let label = UILabel(frame: CGRect(x: 25,
                                          y: self.frame.origin.y,
                                          width: self.frame.width - 10,
                                          height: self.frame.height))
        self.addSubview(label)
        self.titleLabel = label
    }
    
    func setup(title: String?) {
        self.backgroundColor = .white
        
        self.leftView.backgroundColor = .lightGray
        
        self.titleLabel.text = title
        self.titleLabel.textColor = .black
        self.titleLabel.font = .boldSystemFont(ofSize: 25)
        self.titleLabel.textAlignment = .left
        self.titleLabel.backgroundColor = .white
    }
}
