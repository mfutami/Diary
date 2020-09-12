//
//  PrefecturesViewController.swift
//  Diary
//
//  Created by futami on 2020/07/25.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

protocol PrefecturesDelegate: class {
    func startWhether()
}

class PrefecturesViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var prefecturesPickerView: UIPickerView!
    @IBOutlet weak var prefecturesLabel: UILabel!
    @IBOutlet weak var decisionButton: UIButton!
    @IBOutlet weak var decisionButtonBaseView: UIView!
    
    weak var delegate: PrefecturesDelegate?
    
    private var text: String?
    
    private var y = CGFloat() {
        didSet {
            // baseViewの高さを各端末の最大Y座標に設定
            self.baseView.frame.origin.y = UIScreen.main.bounds.maxY
            // 表示
            self.baseView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseView()
        self.setupPickerView()
        self.setupPrefecturesLabel()
        self.setupDecisionButton()
        // 初回表示時 - 初期値として北海道を設定
        self.text = Prefectures.hokkaido.rawValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // baseViewのY座標を保持
        self.y = self.baseView.frame.origin.y
        
        self.startAnimation()
    }
}

private extension PrefecturesViewController {
    func setupBaseView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.alpha = 0.0
        
        self.baseView.backgroundColor = .white
        self.baseView.layer.cornerRadius = 15
        self.baseView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // 初回非表示
        self.baseView.isHidden = true
    }
    
    func setupPickerView() {
        self.prefecturesPickerView.delegate = self
        self.prefecturesPickerView.dataSource = self
        self.prefecturesPickerView.backgroundColor = .white
    }
    
    func setupPrefecturesLabel() {
        self.prefecturesLabel.text = "※天気予報情報取得の為、都道府県を登録いたします。\n以下項目より選択してください。"
        self.prefecturesLabel.textAlignment = .center
        self.prefecturesLabel.textColor = .red
        self.prefecturesLabel.numberOfLines = .zero
        self.prefecturesLabel.sizeToFit()
        self.prefecturesLabel.font = .systemFont(ofSize: 15)
    }
    
    func setupDecisionButton() {
        self.decisionButton.setTitle("OK", for: .normal)
        self.decisionButton.setTitleColor(.black, for: .normal)
        
        self.decisionButton.titleLabel?.font = .systemFont(ofSize: 20)
        
        self.decisionButton.layer.cornerRadius = 15
        self.decisionButton.layer.borderColor = UIColor.black.cgColor
        self.decisionButton.layer.borderWidth = 0.5
        
        self.decisionButton.addTarget(self,
                                      action: #selector(self.tapOkButton),
                                      for: .touchUpInside)
    }
    
    // MARK: - Animation
    
    func startAnimation() {
        // はい希有のViewをanimationで表示
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { self.view.alpha = 1.0 }) { [weak self] _ in
            guard let wself = self else { return }
            // baseViewを下部から保持したY座標までモーダル表示
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                wself.baseView.frame.origin.y = wself.y
            })
        }
    }
    
    func closeAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.baseView.frame.origin.y = UIScreen.main.bounds.maxY
        }) { [weak self] _ in
            self?.dismiss(animated: false)
        }
    }
    
    // MARK: - Action
    
    @objc func tapOkButton() {
        HomeViewModel.setPrefectures(set: true)
        HomeViewModel.setCity(city: self.text)
        self.closeAnimation()
        self.delegate?.startWhether()
    }
}

// MARK: - UIPickerViewDataSource
extension PrefecturesViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int { PrefecturesData.Prefectures.allCases.count }
}

// MARK: - UIPickerViewDelegate
extension PrefecturesViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? { Prefectures.allCases[row].text }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) { self.text = Prefectures.allCases[row].rawValue }
}
