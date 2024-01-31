//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/28.
//

import Foundation
import UIKit

class DictionaryMainViewModel {
    // Properties
    private let monsterMenus = ["1 ~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ 70", "71 ~ 80", "81 ~ 90", "91 ~ 100", "101 ~ 120", "121 ~ 150", "151 ~ 180", "181 ~ 200", "etc"]
    
    private let itemMenus = [
        [
            ItemMenu(title: " 공통 ", image: UIImage(named: "item1")),
            ItemMenu(title: " 전사 ", image: UIImage(named: "item2")),
        ],
        [
            ItemMenu(title: " 궁수 ", image: UIImage(named: "item3")),
            ItemMenu(title: " 도적 ", image: UIImage(named: "item4")),
        ],
        [        
            ItemMenu(title: " 마법사 ", image: UIImage(named: "item5")),
            ItemMenu(title: " 해적 ", image: UIImage(named: "item6")),
        ]


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
    
    func searchItem(name: String, completion: @escaping (DictionaryItem?) -> Void) {
        FirebaseManager.firebaseManager.searchData(name: name, type: DictionaryItem.self) { data in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
    
    func searchMonster(name: String, completion: @escaping (DictionaryMonster?) -> Void) {
        FirebaseManager.firebaseManager.searchData(name: name, type: DictionaryMonster.self) { data in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }
}

struct ItemMenu {
    var title: String
    var image: UIImage?
}
