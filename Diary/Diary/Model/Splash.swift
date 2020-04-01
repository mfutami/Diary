//
//  Splash.swift
//  Diary
//
//  Created by futami on 2019/11/18.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit

class Splash: UIViewController {
    @IBOutlet weak var diaryImage: UIImageView!
    
    private let tabBarModel = TabBerModel()
    
    private var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.diaryImage.image = UIImage(named: "diarySplash")
        self.splashImages()
    }
    
    func splashImages() {
        self.diaryImage.alpha = 0
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseIn], animations: {
            self.diaryImage.alpha = 1
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let viewControllers: [UIViewController] = self.tabBarModel.setupTabBar()
                let tabBarController = UITabBarController()
                tabBarController.setViewControllers(viewControllers, animated: false)
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = tabBarController
                self.window?.makeKeyAndVisible()
                // 初期表示時homeタブが選択状態
                if let tab = self.window?.rootViewController as? UITabBarController  {
                    tab.selectedIndex = 2
                }
            }
        })
    }
}
