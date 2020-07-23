//
//  TabBerModel.swift
//  Diary
//
//  Created by futami on 2019/09/05.
//  Copyright © 2019年 futami. All rights reserved.
//
import UIKit

// MARK: - UITabBarController
class TabBerModel: UITabBarController {
    
    var footerTabBer: [UIViewController] = []
    /// タブバーの設定を各画面ごとに設定
    func setupTabBar() -> [UIViewController] {
        self.setupTabBarColor()
        TabBer.StoryBoard.allCases.forEach {
            guard let storyBoardId = $0.storyBoardId else { return }
            let footerView = UIStoryboard(name: storyBoardId, bundle: nil)
            guard let storyBoard = footerView.instantiateInitialViewController() else { return }
            storyBoard.tabBarItem = UITabBarItem(title: $0.name ?? "",
                                                 image: UIImage(named: $0.image ?? ""),
                                                 tag: $0.tag ?? .zero)
            self.footerTabBer.append(storyBoard)
        }
        return self.footerTabBer
    }
    /// TabBar Color
    private func setupTabBarColor() {
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray
        UITabBar.appearance().barTintColor = .black
    }
}
