//
//  DictLandingViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

import RxSwift
import RxCocoa

class DictLandingViewModel {
    // MARK: - Properties
    
    let sectionDatas = BehaviorRelay<[DictSectionDatas]>(value: [
        DictSectionDatas(iconImage: UIImage(named: "fireIcon"), description: "사람들이 많이 찾는 아이템", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "monsterIcon"), description: "사람들이 많이 찾는 몬스터", datas: [])
    ])
}

// MARK: - Methods
extension DictLandingViewModel {
    
    func fetchSectionDatas() -> [DictSectionDatas] {
        return sectionDatas.value
    }
    
    func setSectionDatasToPopularSearch() {
        let dbManager = SqliteManager()
        FirebaseManager.firebaseManager.fetchDictSearchCount(type: .item) { [weak self] itemSearchCountDatas in
            guard let self = self else { return }
            FirebaseManager.firebaseManager.fetchDictSearchCount(type: .monster) { monsterSearchCountDatas in
                var temp = self.sectionDatas.value
                var itemDatas: [DictSectionData] = []
                var monsterDatas: [DictSectionData] = []
                itemSearchCountDatas.forEach { itemData in
                    dbManager.searchData(dataName: itemData.name) { (items: [DictItem]) in
                        guard let item = items.first else { return }
                        let dictData = DictSectionData(image: item.code, title: item.name, level: item.defaultValues.filter({$0.title == "LEVEL"}).first?.description ?? "-", type: .item)
                        itemDatas.append(dictData)
                    }
                }
                monsterSearchCountDatas.forEach { monsterData in
                    dbManager.searchData(dataName: monsterData.name) { (items: [DictMonster]) in
                        guard let item = items.first else { return }
                        let dictData = DictSectionData(image: item.code, title: item.name, level: item.defaultValues.filter({$0.title == "LEVEL"}).first?.description ?? "-", type: .monster)
                        monsterDatas.append(dictData)
                    }
                }
                temp[0].datas = itemDatas
                temp[1].datas = monsterDatas
                self.sectionDatas.accept(temp)
            }
        }
    }
}
