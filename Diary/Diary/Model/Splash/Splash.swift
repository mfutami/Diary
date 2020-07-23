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
        UIView.animate(withDuration: 2.0,
                       delay: 1.0,
                       options: [.curveEaseIn],
                       animations: { self.diaryImage.alpha = 1 } ) { [weak self] _ in
                        guard let wself = self else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            let tabBarController = UITabBarController()
                            tabBarController.setViewControllers(wself.tabBarModel.setupTabBar(), animated: false)
                            
                            wself.window = UIWindow(frame: UIScreen.main.bounds)
                            wself.window?.rootViewController = tabBarController
                            wself.window?.makeKeyAndVisible()
                            // 初期表示時homeタブが選択状態
                            if let tab = wself.window?.rootViewController as? UITabBarController  {
                                tab.selectedIndex = 2
                            }
                        }
        }
    }
}
