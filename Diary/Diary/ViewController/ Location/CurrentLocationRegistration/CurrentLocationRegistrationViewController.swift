//
//  CurrentLocationRegistrationViewController.swift
//  Diary
//
//  Created by futami on 2020/06/19.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class CurrentLocationRegistrationViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    private let locationViewController = LocationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseView()
        self.setupTitleLabel()
        self.setupTextField()
        self.setupOkButton()
    }
}

private extension CurrentLocationRegistrationViewController {
    func setupBaseView() {
        self.baseView.backgroundColor = .white
        self.baseView.layer.cornerRadius = 20
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        self.baseView.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        // 影の色
        self.baseView.layer.shadowColor = UIColor.lightGray.cgColor
        // 影の濃さ
        self.baseView.layer.shadowOpacity = 0.5
        // 影をぼかし
        self.baseView.layer.shadowRadius = 2
    }
    
    func setupTitleLabel() {
        self.titleLabel.text = "現在位置との距離を比較する為\n地点を登録してください\n\n~注意事項~\n①末尾が市区町村でない場合登録できません。\n②正式な地点名でないと正確な距離が算出されません。"
        self.titleLabel.textColor = .lightGray
        self.titleLabel.backgroundColor = .white
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = .systemFont(ofSize: 15)
        self.titleLabel.numberOfLines = .zero
    }
    
    func setupTextField() {
        self.textField.placeholder = "例: 東京都豊島区"
        self.textField.keyboardType = .default
        self.textField.borderStyle = .roundedRect
        self.textField.returnKeyType = .done
        self.textField.clearButtonMode = .whileEditing
        self.textField.becomeFirstResponder()
        self.textField.delegate = self
        // 登録情報変更の場合 - userdefualtに登録されていたら表示
        self.textField.text = LocationViewModel.registrationData
    }
    
    func setupOkButton() {
        self.okButton.setTitle("OK", for: .normal)
        self.okButton.setTitleColor(.black, for: .normal)
        self.okButton.setTitleColor(.lightGray, for: .highlighted)
        self.okButton.titleLabel?.font = .systemFont(ofSize: 25)
        
        self.okButton.layer.cornerRadius = 15
        self.okButton.layer.borderColor = UIColor.black.cgColor
        self.okButton.layer.borderWidth = 0.5
        
        self.okButton.isEnabled = false
        self.okButton.addTarget(self,
                                action: #selector(self.tapOkButton),
                                for: .touchUpInside)
    }
    
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
        if textField.text?.suffix(1) == "市"
            || textField.text?.suffix(1) == "区"
            || textField.text?.suffix(1) == "町"
            || textField.text?.suffix(1) == "村" {
            self.okButton.isEnabled = true
            LocationViewModel.registrationData = textField.text
        }
        return true
    }
}
