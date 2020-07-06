//
//  LocationDataCell.swift
//  Diary
//
//  Created by futami on 2020/05/12.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class LocationDataCell: UITableViewCell {
    static let identifier = "LocationDataCell"
    
    @IBOutlet weak var presentLocationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var registrationPointLabel: UILabel!
    
    func setup(presentLocation: String, distanceString: String, registrationPoint: String) {
        self.presentLocationLabel.text = presentLocation
        self.presentLocationLabel.font = .systemFont(ofSize: 20)
        self.presentLocationLabel.textColor = .black
        self.presentLocationLabel.numberOfLines = .zero
        
        self.distanceLabel.text = distanceString + "m"
        self.distanceLabel.font = .systemFont(ofSize: 20)
        self.distanceLabel.textColor = .black
        self.distanceLabel.numberOfLines = .zero
        
        self.registrationPointLabel.text = "登録地点（\(registrationPoint)）からの距離"
        self.registrationPointLabel.textColor = .red
        self.registrationPointLabel.font = .systemFont(ofSize: 10)
        self.registrationPointLabel.textAlignment = .right
        self.registrationPointLabel.sizeToFit()
    }
}
