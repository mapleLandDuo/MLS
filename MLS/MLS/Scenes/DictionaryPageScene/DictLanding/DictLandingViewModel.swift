//
//  DictLandingViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

struct DictSectionDatas {
    let iconImage: UIImage?
    let description: String
    var datas: [DictSectionData]
}

struct DictSectionData {
    let image: String
    let title: String
    let level: String
    let type: DictType
}

enum DictType {
    case item
    case monster
    case npc
    case map
    case quest
}

class DictLandingViewModel {
    // MARK: - Properties

    let sectionHeaderInfos: Observable<[DictSectionDatas]> = Observable([
        DictSectionDatas(iconImage: UIImage(named: "fireIcon"), description: "사람들이 많이 찾는 아이템", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "monsterIcon"), description: "레벨에 맞는 추천 몬스터", datas: []),
    ])
}

// MARK: - Methods
extension DictLandingViewModel {
    
    func fetchSectionHeaderInfos() -> [DictSectionDatas]? {
        return sectionHeaderInfos.value
    }
    
    func fetchSectionDatas() {
        sectionHeaderInfos.value?[0].datas = [
            DictSectionData(image: "testItem1", title: "testItem1", level: "20", type: .item),
            DictSectionData(image: "testItem2", title: "testItem2", level: "20", type: .item),
            DictSectionData(image: "testItem3", title: "testItem3", level: "20", type: .item),
            DictSectionData(image: "testItem4", title: "testItem4", level: "20", type: .item),
            DictSectionData(image: "testItem5", title: "testItem5", level: "20", type: .item),
        ]
        sectionHeaderInfos.value?[1].datas = [
            DictSectionData(image: "testMonster1", title: "testMonster1", level: "20", type: .monster),
            DictSectionData(image: "testMonster2", title: "testMonster2", level: "20", type: .monster),
            DictSectionData(image: "testMonster3", title: "testMonster3", level: "20", type: .monster),
            DictSectionData(image: "testMonster4", title: "testMonster4", level: "20", type: .monster),
            DictSectionData(image: "testMonster5", title: "testMonster5", level: "20", type: .monster),
            DictSectionData(image: "testMonster6", title: "testMonster6", level: "20", type: .monster),
            DictSectionData(image: "testMonster7", title: "testMonster7", level: "20", type: .monster),
            DictSectionData(image: "testMonster8", title: "testMonster8", level: "20", type: .monster),
            DictSectionData(image: "testMonster9", title: "testMonster9", level: "20", type: .monster),
        ]
    }
}
