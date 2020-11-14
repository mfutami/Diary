//
//  NewsCollectionViewCell.swift
//  Diary
//
//  Created by futami on 2020/03/29.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewsCollectionViewCell"
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    func setup(image: String, text: String) {
        ImageItems.getImageByUrl(urlString: image) { [weak self] image in
            DispatchQueue.main.async {
                self?.newsImage.image = image
            }
        }
        self.newsImage.layer.cornerRadius = 10
        self.newsImage.contentMode = .scaleAspectFill
        
        self.textLabel.text = text
        self.textLabel.font = .systemFont(ofSize: 15)
        self.textLabel.numberOfLines = 0
        self.textLabel.adjustsFontSizeToFitWidth = true
        
        self.baseView.layer.cornerRadius = 10
        self.baseView.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        self.baseView.layer.shadowColor = UIColor.lightGray.cgColor
        self.baseView.layer.shadowOpacity = 0.5
        self.baseView.layer.shadowRadius = 2
    }
}
