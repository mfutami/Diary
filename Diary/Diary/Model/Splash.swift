//
//  Splash.swift
//  Diary
//
//  Created by futami on 2019/11/18.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import LTMorphingLabel

class Splash: UIViewController {
    @IBOutlet weak var ltmorphingLabel: LTMorphingLabel!
    //表示制御用タイマー
    private var timer: Timer?
    //String配列のindex用
    private var index: Int = 0
    //表示するString配列
    private let textList = ["Let's", "Let's remember today"]
    
    private let tabBarModel = TabBerModel()
    
    private var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewControllers: [UIViewController] = self.tabBarModel.setupTabBar()
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        self.ltmorphingLabel.morphingEffect = .scale
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //タイマーの追加
        self.timer = Timer.scheduledTimer(timeInterval: 1.5,
                                          target: self,
                                          selector: #selector(update(timer:)), userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
    }
    
    @objc func update(timer: Timer) {
        //ここでtextの更新
        self.ltmorphingLabel.text = textList[self.index]
        
        self.index += 1
        if self.index >= textList.count {
            self.index = 0
            self.timer?.invalidate()
            // タイアー破棄後、2秒後にHOME画面表示
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let viewControllers: [UIViewController] = self?.tabBarModel.setupTabBar() else { return }
                
                let tabBarController = UITabBarController()
                tabBarController.setViewControllers(viewControllers, animated: false)
                
                self?.window = UIWindow(frame: UIScreen.main.bounds)
                self?.window?.rootViewController = tabBarController
                self?.window?.makeKeyAndVisible()
                // 初期表示時homeタブが選択状態
                if let tab = self?.window?.rootViewController as? UITabBarController  {
                    tab.selectedIndex = 2
                }
            }
            
        }
    }
}
