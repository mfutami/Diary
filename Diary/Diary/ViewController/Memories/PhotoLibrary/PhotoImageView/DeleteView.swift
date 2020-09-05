//
//  DeleteView.swift
//  Diary
//
//  Created by futami on 2020/08/29.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DeleteView: UIView {
    private var deleteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubView()
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubView()
        self.setupButton()
    }
    
    func setupSubView() {
        self.backgroundColor = .lightGray
        
        let button = UIButton(frame: CGRect(x: self.frame.maxX - 50,
                                            y: self.frame.origin.y,
                                            width: 50,
                                            height: self.frame.height))
        self.addSubview(button)
        self.deleteButton = button
    }
    
    func setupButton() {
        self.deleteButton.isEnabled = false
        
        self.deleteButton.backgroundColor = .lightGray
        
        self.setButtonText()
        self.deleteButton.setTitleColor(.white, for: .normal)
        self.deleteButton.titleLabel?.textAlignment = .right
        
        self.deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
    }
    
    func setButtonText(countText: Int? = nil) {
        self.deleteButton.setTitle("削除\((countText ?? .zero))", for: .normal)
    }
    
    func setupOrigin(y: CGFloat) {
        self.frame.origin.y = (y - 60)
        self.deleteButton.frame.origin.y = self.frame.origin.y
    }
    
    func setupMaxY() {
        self.frame.origin.y = UIScreen.main.bounds.maxY
        self.deleteButton.frame.origin.y = self.frame.origin.y
    }
}

extension DeleteView: DeletePhotoDelegate {
    func selectView(count: Int) {
        self.setButtonText(countText: count)
    }
}
