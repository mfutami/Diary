//
//  HomeViewController.swift
//  Diary
//
//  Created by futami on 2019/09/08.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.home)
        self.timerView()
    }
    
    var baseColor: UIColor {
        return UIColor.init(red: 220/255, green: 223/255, blue: 223/255, alpha: 100/100)
    }
    
    var symbolColor: UIColor {
        return UIColor.init(red: 113/255, green: 107/255, blue: 107/255, alpha: 100/100)
    }
    
    // Navugation Bar
    func setupNavigation(_ setTitle: navigationTitle) {
        self.navigationController?.navigationItem(title: setTitle.title)
    }
    
    var setFrame: CGRect {
        let frame = CGRect(x: self.view.frame.origin.x,
                           y: self.view.frame.origin.y,
                           width: self.view.frame.size.width,
                           height: self.view.frame.size.height)
        return frame
    }
    
    var nowDate: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: now)
    }
    
    var nowTimer: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        let now = Date()
        return dateFormatter.string(from: now)
    }
    
    func timerView() {
        let frame = self.setFrame
        let timerCgRect = CGRect(x: frame.origin.x + 30,
                                y: frame.origin.y + 70,
                                width: frame.width - 60,
                                height: 100)
        
        let daysLabel = UILabel()
        daysLabel.frame = timerCgRect
        daysLabel.backgroundColor = .white
        daysLabel.numberOfLines = 0
        daysLabel.text = "\(self.nowDate)\n\(self.nowTimer)"
        daysLabel.textColor = .black
        daysLabel.textAlignment = .center
        daysLabel.font = UIFont(name: "Avenir", size: 25)
        
        daysLabel.layer.cornerRadius = 10
        daysLabel.layer.borderWidth = 1
        daysLabel.clipsToBounds = true
        
        self.view.addSubview(daysLabel)
    }
}
