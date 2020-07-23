//
//  SlideView.swift
//  Diary
//
//  Created by futami on 2020/05/29.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

protocol PhotoLibraryDelegate: class {
    func showPhotoLibrary()
}

class SlideView: UIView {
    private var rightFrame: CGRect?
    private var leftFrame: CGRect?
    
    private var tapFrags = false
    
    private var slideView: UIView!
    
    private var leftButton: UIButton!
    private var rightButton: UIButton!
    
    weak var delegate: PhotoLibraryDelegate?
    
    private var getLeftFrame: CGRect {
        return CGRect(x: self.bounds.origin.x + 5,
                      y: self.bounds.origin.y + 5,
                      width: self.bounds.size.width / 2,
                      height: self.bounds.size.height - 10)
    }
    
    private var getRightFrame: CGRect {
        return CGRect(x: (self.bounds.maxX / 2) - 5,
                      y: self.bounds.origin.y + 5,
                      width: self.bounds.size.width / 2,
                      height: self.bounds.size.height - 10)
    }
    
    private var colorCode: UIColor {
        return UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupView()
        self.setupSlideView()
        self.slideViewFrame()
        self.setupButton(self.leftButton, title: "カメラ")
        self.setupButton(self.rightButton, title: "アルバム")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
        self.setupView()
        self.setupSlideView()
        self.slideViewFrame()
        self.setupButton(self.leftButton, title: "カメラ")
        self.setupButton(self.rightButton, title: "アルバム")
    }
    
    private func setup() {
        let leftButton = UIButton(frame: self.getLeftFrame)
        self.addSubview(leftButton)
        self.leftButton = leftButton
        
        let rightButton = UIButton(frame: self.getRightFrame)
        self.addSubview(rightButton)
        self.rightButton = rightButton
        
        let view = UIView(frame: self.getLeftFrame)
        self.addSubview(view)
        self.slideView = view
    }
    
    private func setupView() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 8
    }
    
    private func setupSlideView() {
        self.slideView.backgroundColor = .white
        self.slideView.layer.cornerRadius = 8
        self.slideView.alpha = 0.5
    }
    
    private func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .lightGray
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self,
                         action: #selector(self.tapSlideButton),
                         for: .touchUpInside)
    }
    
    private func slideViewFrame() {
        self.rightFrame = self.getRightFrame
        
        self.leftFrame = self.slideView.frame
    }
    
    private func setRightFrame() {
        guard let rightFrame = self.rightFrame else { return }
        self.slideView.frame = rightFrame
    }
    
    private func setLeftFrame() {
        guard let leftFrame = self.leftFrame else { return }
        self.slideView.frame = leftFrame
    }
    
    func slideAnimation() {
        UIView.animate(withDuration: 0.3) {
            if !self.tapFrags {
                // アルバムタブ
                self.setRightFrame()
                self.delegate?.showPhotoLibrary()
            } else {
                // カメラタブ
                self.setLeftFrame()
            }
            self.tapFrags = !self.tapFrags
        }
    }
    
    @objc func tapSlideButton() {
        self.slideAnimation()
    }
}
