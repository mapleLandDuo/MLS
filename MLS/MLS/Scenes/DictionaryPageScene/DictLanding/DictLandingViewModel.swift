//
//  DictLandingViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 2/18/24.
//

import UIKit

class DictLandingViewModel {
    // MARK: - Properties

    let sectionHeaderInfos: Observable<[DictSectionDatas]> = Observable([
        DictSectionDatas(iconImage: UIImage(named: "fireIcon"), description: "사람들이 많이 찾는 아이템", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "monsterIcon"), description: "사람들이 많이 찾는 몬스터", datas: []),
    ])
}

// MARK: - Methods
extension DictLandingViewModel {
    
    func fetchSectionHeaderInfos() -> [DictSectionDatas] {
        guard let data = sectionHeaderInfos.value else { return [] }
        return data
    }
    
    func fetchSectionDatas() {
        
        let dbManager = SqliteManager()
        
        FirebaseManager.firebaseManager.fetchDictSearchCount(type: .item) { [weak self] searchCountDatas in
            var temp: [DictSectionData] = []
            for data in searchCountDatas {
                dbManager.searchData(dataName: data.name) { (items:[DictItem]) in
                    guard let item = items.first else { return }
                    let dictData = DictSectionData(image: item.code, title: item.name, level: item.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "-", type: .item)
                    temp.append(dictData)
                }
            }
            self?.sectionHeaderInfos.value?[0].datas = temp
        }
        
        FirebaseManager.firebaseManager.fetchDictSearchCount(type: .monster) { [weak self] searchCountDatas in
            var temp: [DictSectionData] = []
            for data in searchCountDatas {
                dbManager.searchData(dataName: data.name) { (items:[DictMonster]) in
                    guard let item = items.first else { return }
                    let dictData = DictSectionData(image: item.code, title: item.name, level: item.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "-", type: .monster)
                    temp.append(dictData)
                }
            }
            self?.sectionHeaderInfos.value?[1].datas = temp
        }
    }
}
