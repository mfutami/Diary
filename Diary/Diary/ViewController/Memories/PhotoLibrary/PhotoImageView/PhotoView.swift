//
//  PhotoView.swift
//  Diary
//
//  Created by futami on 2020/06/19.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

protocol PhotoViewDelegate: class {
    func removeNavigationLeftItem()
}

class PhotoView: UIView {
    
    private var photoImageView: UIImageView!
    
    weak var photoDelegate: PhotoViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        
        let imageView = UIImageView(frame: self.frame)
        self.addSubview(imageView)
        self.photoImageView = imageView
    }
    
    func setupImageView(imageView: UIImageView) {
        self.photoImageView.contentMode = .scaleAspectFit
        self.photoImageView.image = imageView.image
    }
    
    @objc func tapCloseButton() {
        self.photoDelegate?.removeNavigationLeftItem()
        self.removeFromSuperview()
    }
}
