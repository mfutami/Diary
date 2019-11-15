//
//  TabBerModel.swift
//  Diary
//
//  Created by futami on 2019/09/05.
//  Copyright © 2019年 futami. All rights reserved.
//

import RAMAnimatedTabBarController

protocol TabBarProtocol: RAMItemAnimationProtocol {
    func playAnimation(_ icon: UIImageView, textLabel: UILabel)
    func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor)
    func selectedState(_ icon: UIImageView, textLabel: UILabel)
}

// MARK - UITabBarController
class TabBerModel: UITabBarController {
    private var ramAnimation = RAMItemAnimation()
    private var ramBounceAnimation = RAMBounceAnimation()
    
    var footerTabBer: [UIViewController] = []
    // タブバーの設定を各画面ごとに設定
    func setupTabBar() -> [UIViewController] {
        self.setupTabBarColor()
        Footer.allCases.forEach {
            guard let storyBoardId = $0.storyBoardId,
                let image = $0.image,
                let tag = $0.tag,
                let name = $0.name else { return }
            let footerView = UIStoryboard(name: storyBoardId, bundle: nil)
            guard let storyBoard = footerView.instantiateInitialViewController() else { return }
            storyBoard.tabBarItem = UITabBarItem(title: name, image: UIImage(named: image), tag: tag)
            footerTabBer.append(storyBoard)
        }
        return self.footerTabBer
    }
    // TabBar Color
    func setupTabBarColor() {
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        UITabBar.appearance().barTintColor = UIColor.black
    }
}
