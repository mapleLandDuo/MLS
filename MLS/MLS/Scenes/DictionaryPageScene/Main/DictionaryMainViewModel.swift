//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/28.
//

import UIKit

class DictionaryMainViewModel {
    // Properties
    private let monsterMenus = ["1 ~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ 70", "71 ~ 80", "81 ~ 90", "91 ~ 100", "101 ~ 110", "111 ~ 120", "121 ~ 130", "131 ~ 140", "141 ~ 150", "etc"]

    private let itemMenus = [
        [
            ItemMenu(title: .common, image: UIImage(named: "commonIcon")),
            ItemMenu(title: .warrior, image: UIImage(named: "warriorIcon")),
        ],
        [
            ItemMenu(title: .archer, image: UIImage(named: "archerIcon")),
            ItemMenu(title: .thief, image: UIImage(named: "thiefIcon")),
        ],
        [
            ItemMenu(title: .magician, image: UIImage(named: "magicianIcon")),
            ItemMenu(title: .pirate, image: UIImage(named: "pirateIcon")),
        ],
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

    func getItemMenu() -> [[ItemMenu]] {
        return itemMenus
    }

    func getItemMenuCount() -> Int {
        return itemMenus.count
    }

    func searchItem(name: String, completion: @escaping ([DictionaryItem]?) -> Void) {
        FirebaseManager.firebaseManager.searchData(name: name, type: DictionaryItem.self) { data in
            if let data = data {
                if data.isEmpty {
                    completion(nil)
                } else {
                    completion(data)
                }
            } else {
                completion(nil)
            }
        }
    }

    func searchMonster(name: String, completion: @escaping ([DictionaryMonster]?) -> Void) {
        FirebaseManager.firebaseManager.searchData(name: name, type: DictionaryMonster.self) { data in
            if let data = data {
                if data.isEmpty {
                    completion(nil)
                } else {
                    completion(data)
                }
            } else {
                completion(nil)
            }
        }
    }

    func loadItemByRoll(roll: String, completion: @escaping ([DictionaryItem]) -> Void) {
        FirebaseManager.firebaseManager.loadItemByRoll(roll: roll) { items in
            completion(items)
        }
    }

    func loadMonsterByLevel(minLevel: Int, maxLevel: Int, completion: @escaping ([DictionaryMonster]) -> Void) {
        FirebaseManager.firebaseManager.loadMonsterByLevel(minLevel: minLevel, maxLevel: maxLevel) { monsters in
            completion(monsters)
        }
    }
}

struct ItemMenu {
    var title: ItemMenuName
    var image: UIImage?
}

enum ItemMenuName: String {
    case common = "공용"
    case warrior = "전사"
    case archer = "궁수"
    case thief = "도적"
    case magician = "법사"
    case pirate = "해적"
}
