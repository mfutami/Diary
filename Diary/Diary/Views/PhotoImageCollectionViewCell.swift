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
    
    func setup(data: Data) {
        self.photoImageView.image = UIImage(data: data)
        self.photoImageView.contentMode = .scaleToFill
        
        self.photoImageView.layer.cornerRadius = 5
    }
}
