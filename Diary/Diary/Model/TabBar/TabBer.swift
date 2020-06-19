//
//  TabBer.swift
//  Diary
//
//  Created by futami on 2019/09/03.
//  Copyright © 2019年 futami. All rights reserved.
//

typealias Footer = TabBer.StoryBoard

class TabBer {
    enum StoryBoard: CaseIterable {
        case diary
        case memories
        case home
        case news
        case location
        
        var storyBoardId: String? {
            switch self {
            case .diary:
                return "Diary"
            case .memories:
                return "Memories"
            case .home:
                return "Home"
            case .news:
                return "News"
            case .location:
                return "Location"
            }
        }
        
        var image: String? {
            switch self {
            case .diary:
                return "diary"
            case .memories:
                return "camera"
            case .home:
                return "home"
            case .news:
                return "news"
            case .location:
                return "location"
            }
        }
        
        var tag: Int? {
            switch self {
            case .diary:
                return 1
            case .memories:
                return 2
            case .home:
                return 3
            case .news:
                return 4
            case .location:
                return 5
            }
        }
        
        var name: String? {
            switch self {
            case .diary:
                return String.LocalizedString("diaryIconName", tableName: "TabBar")
            case .memories:
                return String.LocalizedString("memoriesIconName", tableName: "TabBar")
            case .home:
                return String.LocalizedString("homeIconName", tableName: "TabBar")
            case .news:
                return String.LocalizedString("newsIconName", tableName: "TabBar")
            case .location:
                return String.LocalizedString("locationIconName", tableName: "TabBar")
            }
        }
    }
}
