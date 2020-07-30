//
//  Navigation.swift
//  Diary
//
//  Created by futami on 2020/07/20.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

extension UINavigationController {
    func navigationItem(title: String, viewController: UIViewController) {
        viewController.title = title
        self.navigationBar.barTintColor = .white
        self.navigationBar.tintColor = .black
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
}
