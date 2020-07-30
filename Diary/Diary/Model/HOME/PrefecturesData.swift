//
//  PrefecturesData.swift
//  Diary
//
//  Created by futami on 2020/07/25.
//  Copyright © 2020 futami. All rights reserved.
//

import Foundation

typealias Prefectures = PrefecturesData.Prefectures

struct PrefecturesData {
    enum Prefectures: String, CaseIterable {
        case hokkaido = "Hokkaido"
        case aomori = "Aomori"
        case iwate = "Iwate"
        case miyagi = "Miyagi"
        case akita = "Akita"
        case yamagata = "Yamagata"
        case fukushima = "Fukushima"
        case ibaraki = "Ibaraki"
        case Tochigi = "Tochigi"
        case gunma = "Gunma"
        case saitama = "Saitama"
        case chiba = "Chiba"
        case tokyo = "Tokyo"
        case kanagawa = "Kanagawa"
        case niigata = "Niigata"
        case toyama = "Toyama"
        case ishikawa = "Ishikawa"
        case fukui = "Fukui"
        case yamanashi = "Yamanashi"
        case nagano = "Nagano"
        case gifu = "Gifu"
        case shizuoka = "Shizuoka"
        case aichi = "Aichi"
        case mie = "Mie"
        case shiga = "Shiga"
        case kyoto = "Kyoto"
        case osaka = "Osaka"
        case hyogo = "Hyogo"
        case nara = "Nara"
        case wakayama = "Wakayama"
        case tottori = "Tottori"
        case shimane = "Shimane"
        case okayama = "Okayama"
        case hiroshima = "Hiroshima"
        case yamaguchi = "Yamaguchi"
        case tokushima = "Tokushima"
        case kagawa = "Kagawa"
        case ehime = "Ehime"
        case kochi = "Kochi"
        case fukuoka = "Fukuoka"
        case saga = "Saga"
        case nagasaki = "Nagasaki"
        case kumamoto = "Kumamoto"
        case oita = "Oita"
        case miyazaki = "Miyazaki"
        case kagoshima = "Kagoshima"
        case okinawa = "Okinawa"
        
        var text: String {
            switch self {
            case .hokkaido:
                return "北海道"
            case .aomori:
                return "青森"
            case .iwate:
                return "岩手"
            case .miyagi:
                return "宮城"
            case .akita:
                return "秋田"
            case .yamagata:
                return "山形"
            case .fukushima:
                return "福島"
            case .ibaraki:
                return "茨城"
            case .Tochigi:
                return "栃木"
            case .gunma:
                return "群馬"
            case .saitama:
                return "埼玉"
            case .chiba:
                return "千葉"
            case .tokyo:
                return "東京"
            case .kanagawa:
                return "神奈川"
            case .niigata:
                return "新潟"
            case .toyama:
                return "富山"
            case .ishikawa:
                return "石川"
            case .fukui:
                return "福井"
            case .yamanashi:
                return "山梨"
            case .nagano:
                return "長野"
            case .gifu:
                return "岐阜"
            case .shizuoka:
                return "静岡"
            case .aichi:
                return "愛知"
            case .mie:
                return "三重"
            case .shiga:
                return "滋賀"
            case .kyoto:
                return "京都"
            case .osaka:
                return "大阪"
            case .hyogo:
                return "兵庫"
            case .nara:
                return "奈良"
            case .wakayama:
                return "和歌山"
            case .tottori:
                return "鳥取"
            case .shimane:
                return "島根"
            case .okayama:
                return "岡山"
            case .hiroshima:
                return "広島"
            case .yamaguchi:
                return "山口"
            case .tokushima:
                return "徳島"
            case .kagawa:
                return "香川"
            case .ehime:
                return "愛媛"
            case .kochi:
                return "高知"
            case .fukuoka:
                return "福岡"
            case .saga:
                return "佐賀"
            case .nagasaki:
                return "長崎"
            case .kumamoto:
                return "熊本"
            case .oita:
                return "大分"
            case .miyazaki:
                return "宮崎"
            case .kagoshima:
                return "鹿児島"
            case .okinawa:
                return "沖縄"
            }
        }
    }
}
