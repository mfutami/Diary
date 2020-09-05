//
//  PhotoImageCollectionViewCell.swift
//  Diary
//
//  Created by futami on 2020/06/03.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class PhotoImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoImageCollectionViewCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // デフォルト非表示
        self.shadowView.isHidden = true
        self.checkImage.isHidden = true
    }
    
    func setup(data: Data) {
        self.photoImageView.image = UIImage(data: data)
        self.photoImageView.contentMode = .scaleToFill
        
        self.photoImageView.layer.cornerRadius = 5
    }
    
    func setIsHidden(hidden: Bool) {
        self.shadowView.isHidden = hidden
        self.checkImage.isHidden = hidden
    }
}
