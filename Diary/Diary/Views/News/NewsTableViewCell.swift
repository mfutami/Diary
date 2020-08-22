//
//  NewsTableViewCell.swift
//  Diary
//
//  Created by futami on 2019/11/01.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    func setupCell(title: String, imageUrl: String) {
        ImageItems.getImageByUrl(url: imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.newsImage.image = image
            }
        }
        self.newsImage.contentMode = .scaleToFill
        self.newsImage.layer.cornerRadius = 10
        self.newsImage.clipsToBounds = true
        
        self.newsTitle.text = title
        self.newsTitle.font = .systemFont(ofSize: 15)
        self.newsTitle.numberOfLines = 0
        
        self.baseView.layer.cornerRadius = 10
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        self.baseView.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        // 影の色
        self.baseView.layer.shadowColor = UIColor.lightGray.cgColor
        // 影の濃さ
        self.baseView.layer.shadowOpacity = 0.5
        // 影をぼかし
        self.baseView.layer.shadowRadius = 2
        
    }
}
