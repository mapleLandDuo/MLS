//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/29.
//

import Foundation

class DictionarySearchViewModel {
    // MARK: Properties

    let type: SearchType
    let item: Observable<DictionaryItem> = Observable(nil)
    let monster: Observable<DictionaryMonster> = Observable(nil)
//    let itemList: Observable<[DictionaryItem]> = Observable(nil)
//    let monsterList: Observable<[DictionaryMonster]> = Observable(nil)

    init(type: SearchType) {
        self.type = type
    }
}

extension DictionarySearchViewModel {
    // MARK: Method

    func getURL() -> URL? {
        switch type {
        case .item:
            guard let code = item.value?.code ,let url = URL(string: "https://maplestory.io/api/gms/62/item/\(code)/icon") else { return nil }
            return url
        case .monster:
            guard let code = monster.value?.code ,let url = URL(string: "https://maplestory.io/api/gms/62/mob/\(code)/render/move?bgColor=") else { return nil }
            return url
        }
    }
//    func getItemListCount() -> Int {
//        if let count = itemList.value?.count {
//            return count
//        }
//        return 0
//    }
//
//    func getMonsterListCount() -> Int {
//        if let count = monsterList.value?.count {
//            return count
//        }
//        return 0
//    }
}

enum SearchType {
    case item
    case monster
}
