//
//  NonDateLoggerLabel.swift
//  Diary
//
//  Created by futami on 2020/05/09.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class NonDateLoggerLabel: UILabel {
    private var nonDateTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = .white
        self.text = "表示する記録データがありません。\n現在位置を記録した場合に記録が表示されます。"
        self.textColor = .red
        self.textAlignment = .center
        self.numberOfLines = .zero
        self.font = .systemFont(ofSize: 15)
    }
}
