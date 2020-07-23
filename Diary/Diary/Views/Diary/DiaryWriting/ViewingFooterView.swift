//
//  ViewingFooterView.swift
//  Diary
//
//  Created by futami on 2020/06/26.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class ViewingFooterView: UIView {
    
    private var closeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubViews()
        self.setup()
    }
    
    private func setupSubViews() {
        let button = UIButton(frame: CGRect(x: 5,
                                            y: self.frame.origin.y,
                                            width: (self.frame.width) - 5,
                                            height: self.frame.height))
        self.addSubview(button)
        self.closeButton = button
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        
        self.closeButton.setTitle("閉じる", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.closeButton.titleLabel?.font = .systemFont(ofSize: 25)
        self.closeButton.titleLabel?.textAlignment = .center
    }
}
