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
    let itemList: Observable<[DictionaryItem]> = Observable(nil)
    let monsterList: Observable<[DictionaryMonster]> = Observable(nil)

    init(type: SearchType) {
        self.type = type
    }
}

extension DictionarySearchViewModel {
    // MARK: Method

    func getItemListCount() -> Int {
        if let count = itemList.value?.count {
            return count
        }
        return 0
    }

    func getMonsterListCount() -> Int {
        if let count = monsterList.value?.count {
            return count
        }
        return 0
    }
}

enum SearchType {
    case item
    case monster
}
