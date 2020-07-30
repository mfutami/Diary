//
//  WhetherResult.swift
//  Diary
//
//  Created by futami on 2020/07/25.
//  Copyright © 2020 futami. All rights reserved.
//

import Foundation

struct WhetherResult {
    /// 気温
    let temp: Double
    /// 最低気温
    let temp_min: Double
    /// 最高気温
    let temp_max: Double
    /// 湿度
    let humidity: Double
    /// 天気
    let main: String
    /// 天気アイコン
    let icon: String
    /// 登録地点
    let cityName: String
}
