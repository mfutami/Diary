//
//  CurrentLocationRegistrationViewController.swift
//  Diary
//
//  Created by futami on 2020/06/19.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class CurrentLocationRegistrationViewController: UIViewController {
    @IBOutlet weak var baseView: UIView! {
        willSet {
            newValue.backgroundColor = .white
            newValue.layer.cornerRadius = 20
            // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
            newValue.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
            // 影の色
            newValue.layer.shadowColor = UIColor.lightGray.cgColor
            // 影の濃さ
            newValue.layer.shadowOpacity = 0.5
            // 影をぼかし
            newValue.layer.shadowRadius = 2
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        willSet {
            newValue.text = "現在位置との距離を比較する為\n地点を登録してください\n\n~注意事項~\n①末尾が市区町村でない場合登録できません。\n②正式な地点名でないと正確な距離が算出されません。"
            newValue.textColor = .lightGray
            newValue.backgroundColor = .white
            newValue.textAlignment = .center
            newValue.font = .systemFont(ofSize: 15)
            newValue.numberOfLines = .zero
        }
    }
    @IBOutlet weak var textField: UITextField! {
        willSet {
            newValue.placeholder = "例: 東京都豊島区"
            newValue.keyboardType = .default
            newValue.borderStyle = .roundedRect
            newValue.returnKeyType = .done
            newValue.clearButtonMode = .whileEditing
            newValue.delegate = self
        }
    }
    @IBOutlet weak var okButton: UIButton! {
        willSet {
            newValue.setTitle("OK", for: .normal)
            newValue.setTitleColor(.black, for: .normal)
            newValue.setTitleColor(.lightGray, for: .highlighted)
            newValue.titleLabel?.font = .systemFont(ofSize: 25)
            
            newValue.layer.cornerRadius = 15
            newValue.layer.borderColor = UIColor.black.cgColor
            newValue.layer.borderWidth = 0.5
            
            newValue.isEnabled = false
            newValue.addTarget(self,
                               action: #selector(self.tapOkButton),
                               for: .touchUpInside)
        }
    }
    
    private let locationViewController = LocationViewController()
    
    /// 登録地点
    static var registrationData: String?
}

private extension CurrentLocationRegistrationViewController {
    @objc func tapOkButton() {
        self.locationViewController.viewModel.whetherToRegister()
        self.dismiss(animated: false)
    }
}

extension CurrentLocationRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // 以下、末尾文字列が一致した場合にOKボタンを活性, 文字列を保持
        if textField.text?.suffix(1) == "市" ||
            textField.text?.suffix(1) == "区" ||
            textField.text?.suffix(1) == "町" ||
            textField.text?.suffix(1) == "村" {
            self.okButton.isEnabled = true
            CurrentLocationRegistrationViewController.registrationData = textField.text
        }
        return true
    }
}
