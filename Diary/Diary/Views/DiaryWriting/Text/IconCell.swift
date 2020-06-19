//
//  IconCell.swift
//  Diary
//
//  Created by futami on 2020/06/13.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class IconCell: UITableViewCell {
    static let identifier = "IconCell"
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var twitterIcon: UIButton!
    @IBOutlet weak var saveIcon: UIButton!
    
    func setup(_ imageString: String, button: UIButton) {
        button.setImage(UIImage(named: imageString), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.tintColor = .black
    }
    
    func setupBaseView() {
        self.baseView.layer.cornerRadius = 15
        self.baseView.layer.borderWidth = 0.5
        self.baseView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
