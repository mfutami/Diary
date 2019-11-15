//
//  NavigationBar.swift
//  Diary
//
//  Created by futami on 2019/10/29.
//  Copyright © 2019年 futami. All rights reserved.
//
import UIKit

typealias navigationTitle = NavigationBar.NavigationTitle

class NavigationBar {
    enum NavigationTitle: CaseIterable {
        case home
        case diary
        case memories
        case location
        case news
        
        var title: String {
            switch self {
            case .home:
                return "Home"
            case .diary:
                return "Diary"
            case .memories:
                return "Memories"
            case .location:
                return "Location"
            case .news:
                return "News"
            }
        }
    }
}
