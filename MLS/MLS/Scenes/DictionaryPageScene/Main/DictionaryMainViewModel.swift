//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/28.
//

import Foundation

class DictionaryMainViewModel {
    // Properties
    private let monsterMenus = ["1 ~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ 70", "71 ~ 80", "81 ~ 90", "91 ~ 100", "101 ~ 120", "121 ~ 150", "151 ~ 180", "181 ~ 200", "etc"]
    
    private let itemMenus = [
        ItemMenu(title: " 공통 ", image: URL(string: "https://lwi.nexon.com/maplestory/guide/char_info/char_view/char2.jpg")),
        ItemMenu(title: " 전사 ", image: URL(string: "https://lwi.nexon.com/maplestory/guide/char_info/char_view/char1.jpg")),
        ItemMenu(title: " 궁수 ", image: URL(string: "https://lwi.nexon.com/maplestory/guide/char_info/char_view/char23.jpg")),
        ItemMenu(title: " 도적 ", image: URL(string: "https://lwi.nexon.com/maplestory/guide/char_info/char_view/char30.jpg")),
        ItemMenu(title: " 마법사 ", image: URL(string: "https://lwi.nexon.com/maplestory/guide/char_info/char_view/char14.jpg")),
        ItemMenu(title: " 해적 ", image: URL(string: "https://lwi.nexon.com/maplestory/guide/char_info/char_view/char40.jpg")),
    ]
}

extension DictionaryMainViewModel {
    // MARK: Method
    func getMonsterMenu() -> [String] {
        return monsterMenus
    }
    
    func getMonsterMenuCount() -> Int {
        return monsterMenus.count
    }
    
    func getItemMenu() -> [ItemMenu] {
        return itemMenus
    }
    
    func getItemMenuCount() -> Int {
        return itemMenus.count
    }
}

struct ItemMenu {
    var title: String
    var image: URL?
}
