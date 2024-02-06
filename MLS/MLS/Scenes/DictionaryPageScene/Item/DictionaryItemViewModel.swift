//
//  DictionaryItemViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/29/24.
//

import Foundation

class DictionaryItemViewModel {
    // MARK: - Properties

    let item: DictionaryItem

    init(item: DictionaryItem) {
        self.item = item
    }
}

// MARK: - Methods
extension DictionaryItemViewModel {
    func fetchItem() -> DictionaryItem {
        return item
    }

    func fetchDefaultInfoArray() -> [DictionaryNameDescription] {
        let datas = [
            "description": item.description,
            "str": item.str,
            "dex": item.dex,
            "luk": item.luk,
            "int": item.int
        ].filter { $0.value != nil }.compactMapValues { $0! }

        let names = ["설명", "STR", "DEX", "LUK", "INT"]

        let descriptions = ["description", "str", "dex", "luk", "int"]

        var array: [DictionaryNameDescription] = []

        for description in descriptions {
            if let value = datas[description] {
                let name = names[descriptions.firstIndex(of: description)!]
                let item = DictionaryNameDescription(name: name, description: description)
                array.append(item)
            }
        }
        return array
    }

    func fetchDetailInfoArray() -> [DictionaryNameDescription] {
        let temp = item.detailDescription
        
        var array: [DictionaryNameDescription] = []

        let names = ["물리공격력", "마법공격력", "공격속도", "명중률", "이동속도", "성별", "직업", "마법방어력", "물리방어력", "STR", "DEX", "LUK", "INT", "최대마나", "최대체력", "회피율", "상점 판매가"]

        names.forEach { name in
            guard let value = temp[name] else { return }
            let item = DictionaryNameDescription(name: name, description: value)
            array.append(item)
        }
        return array
    }
}
