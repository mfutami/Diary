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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(title: String, imageUrl: String, link: String) {
        guard let image = UIImage.getImageByUrl(url: imageUrl) else { return }
        
        self.newsImage.image = image
        self.newsImage.contentMode = .scaleAspectFit
        
        self.newsTitle.text = title
        self.newsTitle.font = UIFont.systemFont(ofSize: 15)
        
    }
}
