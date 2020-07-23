//
//  TitleCell.swift
//  Diary
//
//  Created by futami on 2020/06/13.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
    static let identifier = "TitleCell"
    @IBOutlet weak var titleTextField: UITextField!
    
    static var textString: String?
    
    func setup(title: String?) {
        // 編集画面初期値設定 - 新規追加の際はnilになる為問題ない
        TitleCell.textString = title
        self.titleTextField.placeholder = "タイトルを入力してください"
        self.titleTextField.keyboardType = .default
        // 枠線を角丸
        self.titleTextField.borderStyle = .roundedRect
        self.titleTextField.returnKeyType = .done
        // 入力値クリアボタン追加
        self.titleTextField.clearButtonMode = .whileEditing
        
        self.titleTextField.text = title
        
        self.titleTextField.delegate = self
    }
}

extension TitleCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        TitleCell.textString = textField.text
        return true
    }
}
