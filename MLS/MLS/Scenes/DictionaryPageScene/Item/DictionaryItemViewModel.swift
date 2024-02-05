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

    func getItem() -> DictionaryItem {
        return item
    }

    func getDefaultInfoArray() -> [DictionaryNameDescription] {
        let datas = [
            "description": item.description,
            "str": item.str,
            "dex": item.dex,
            "luk": item.luk,
            "int": item.int
        ].filter { $0.value != nil }.compactMapValues { $0! }

        var array: [DictionaryNameDescription] = []
        if datas["description"] != nil {
            let item = DictionaryNameDescription(name: "설명", description: datas["description"]!)
            array.append(item)
        }
        if datas["str"] != nil {
            let item = DictionaryNameDescription(name: "STR", description: datas["str"]!)
            array.append(item)
        }
        if datas["dex"] != nil {
            let item = DictionaryNameDescription(name: "DEX", description: datas["dex"]!)
            array.append(item)
        }
        if datas["luk"] != nil {
            let item = DictionaryNameDescription(name: "LUK", description: datas["luk"]!)
            array.append(item)
        }
        if datas["int"] != nil {
            let item = DictionaryNameDescription(name: "INT", description: datas["int"]!)
            array.append(item)
        }
        return array
    }

    func getDetailInfoArray() -> [DictionaryNameDescription] {
        let temp = item.detailDescription
        var array: [DictionaryNameDescription] = []
        if temp["물리공격력"] != nil {
            let item = DictionaryNameDescription(name: "물리공격력", description: temp["물리공격력"]!)
            array.append(item)
        }
        if temp["마법공격력"] != nil {
            let item = DictionaryNameDescription(name: "마법공격력", description: temp["마법공격력"]!)
            array.append(item)
        }
        if temp["공격속도"] != nil {
            let item = DictionaryNameDescription(name: "공격속도", description: temp["공격속도"]!)
            array.append(item)
        }
        if temp["명중률"] != nil {
            let item = DictionaryNameDescription(name: "명중률", description: temp["명중률"]!)
            array.append(item)
        }
        if temp["이동속도"] != nil {
            let item = DictionaryNameDescription(name: "이동속도", description: temp["이동속도"]!)
            array.append(item)
        }
        if temp["성별"] != nil {
            let item = DictionaryNameDescription(name: "성별", description: temp["성별"]!)
            array.append(item)
        }
        if temp["직업"] != nil {
            let item = DictionaryNameDescription(name: "직업", description: temp["직업"]!)
            array.append(item)
        }
        if temp["마법방어력"] != nil {
            let item = DictionaryNameDescription(name: "마법방어력", description: temp["마법방어력"]!)
            array.append(item)
        }
        if temp["물리방어력"] != nil {
            let item = DictionaryNameDescription(name: "물리방어력", description: temp["물리방어력"]!)
            array.append(item)
        }
        if temp["STR"] != nil {
            let item = DictionaryNameDescription(name: "STR", description: temp["STR"]!)
            array.append(item)
        }
        if temp["DEX"] != nil {
            let item = DictionaryNameDescription(name: "DEX", description: temp["DEX"]!)
            array.append(item)
        }
        if temp["LUK"] != nil {
            let item = DictionaryNameDescription(name: "LUK", description: temp["LUK"]!)
            array.append(item)
        }
        if temp["INT"] != nil {
            let item = DictionaryNameDescription(name: "INT", description: temp["INT"]!)
            array.append(item)
        }
        if temp["최대마나"] != nil {
            let item = DictionaryNameDescription(name: "최대마나", description: temp["최대마나"]!)
            array.append(item)
        }
        if temp["최대체력"] != nil {
            let item = DictionaryNameDescription(name: "최대체력", description: temp["최대체력"]!)
            array.append(item)
        }
        if temp["회피율"] != nil {
            let item = DictionaryNameDescription(name: "회피율", description: temp["회피율"]!)
            array.append(item)
        }
        if temp["상점 판매가"] != nil {
            let item = DictionaryNameDescription(name: "상점 판매가", description: temp["상점 판매가"]!)
            array.append(item)
        }
        return array
    }
}
