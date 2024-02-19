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
}
