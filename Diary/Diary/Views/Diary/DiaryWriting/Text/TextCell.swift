//
//  TextCell.swift
//  Diary
//
//  Created by futami on 2020/06/13.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    static let identifier = "TextCell"
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var baseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    static var textViewString: String?
    
    func setup(text: String?) {
        // 編集画面初期値設定 - 新規追加の際はnilになる為問題ない
        TextCell.textViewString = text
        self.baseViewHeight.constant = UIScreen.main.bounds.height / 1.8
        
        self.textView.keyboardType = .default
        // 枠線を角丸
        self.textView.layer.cornerRadius = 15
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.layer.borderWidth = 0.5
        self.textView.returnKeyType = .default
        self.textView.text = text
        
        self.textView.delegate = self
        
        self.setupToolBar()
    }
    
    func setupToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.setItems([UIBarButtonItem(title: "OK",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.tapOkButton))], animated: true)
        toolBar.sizeToFit()
        self.textView.inputAccessoryView = toolBar
    }
    
    @objc func tapOkButton() {
        self.endEditing(true)
    }
}

extension TextCell: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        TextCell.textViewString = textView.text
        return true
    }
}
