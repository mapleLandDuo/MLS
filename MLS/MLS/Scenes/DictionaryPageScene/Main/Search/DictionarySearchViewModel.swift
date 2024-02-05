//
//  File.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/29.
//

import Foundation

enum SearchType {
    case item
    case monster
}

class DictionarySearchViewModel {
    // MARK: Properties

    let type: SearchType

    let itemList: Observable<[DictionaryItem]> = Observable(nil)

    let monsterList: Observable<[DictionaryMonster]> = Observable(nil)

    init(type: SearchType) {
        self.type = type
    }
}

// MARK: Method
extension DictionarySearchViewModel {
    func getURL() -> [URL?] {
        switch type {
        case .item:
            guard let code = itemList.value else { return [] }
            return code.map { URL(string: "https://maplestory.io/api/gms/62/item/\($0.code)/icon") }
        case .monster:
            guard let code = monsterList.value else { return [] }
            return code.map { URL(string: "https://maplestory.io/api/gms/62/mob/\($0.code)/render/move?bgColor=") }
        }
    }

    func getItemListCount() -> Int {
        if let count = itemList.value?.count { return count }
        return 0
    }

    func getMonsterListCount() -> Int {
        if let count = monsterList.value?.count { return count }
        return 0
    }
}
