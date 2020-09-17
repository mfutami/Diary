//
//  NetWorkErrorView.swift
//  Diary
//
//  Created by futami on 2020/09/12.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class NetWorkErrorView: UIView {
    var errorButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
        self.setupButton()
    }
    
    func setup() {
        let button = UIButton(frame: frame)
        self.addSubview(button)
        self.errorButton = button
    }
    
    func setupButton() {
        
    }
}
