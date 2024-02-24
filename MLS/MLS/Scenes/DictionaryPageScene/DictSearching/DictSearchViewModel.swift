//
//  DictSearchViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 2/22/24.
//

import UIKit

class DictSearchViewModel {
    // MARK: - Properties
    let manager = UserDefaultsManager()
    lazy var recentSearchKeywords: Observable<[String]> = Observable(manager.fetchRecentSearchKeyWord())
    let searchMenus: Observable<[String]> = Observable(["전체(0)","몬스터(0)","아이템(0)","맵(0)","NPC(0)","퀘스트(0)"])
    
    let searchData: Observable<[DictSectionDatas]> = Observable([
        DictSectionDatas(iconImage: UIImage(named: "monsterIcon"), description: "몬스터", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "itemIcon"), description: "아이템", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "mapIcon"), description: "맵", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "npcIcon"), description: "NPC", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "questIcon"), description: "퀘스트", datas: [])
    ])
}

extension DictSearchViewModel {
    func fetchSearchData(keyword: String) {
        self.searchData.value?[0].datas.append(DictSectionData(image: "", title: "이블아이", level: "50", type: .monster))
        self.searchData.value?[0].datas.append(DictSectionData(image: "", title: "이블아이", level: "50", type: .monster))
        self.searchData.value?[0].datas.append(DictSectionData(image: "", title: "이블아이", level: "50", type: .monster))
        self.searchData.value?[2].datas.append(DictSectionData(image: "", title: "이블아이의굴", level: "50", type: .map))
        self.searchData.value?[2].datas.append(DictSectionData(image: "", title: "이블아이의굴", level: "50", type: .map))
        self.searchData.value?[2].datas.append(DictSectionData(image: "", title: "이블아이의굴", level: "50", type: .map))
        self.searchData.value?[2].datas.append(DictSectionData(image: "", title: "이블아이의굴", level: "50", type: .map))
        self.searchData.value?[2].datas.append(DictSectionData(image: "", title: "이블아이의굴", level: "50", type: .map))
        self.searchData.value?[2].datas.append(DictSectionData(image: "", title: "이블아이의굴", level: "50", type: .map))
        
        guard let monsterCount = searchData.value?[0].datas.count,
              let itemCount = searchData.value?[1].datas.count,
              let mapCount = searchData.value?[2].datas.count,
              let npcCount = searchData.value?[3].datas.count,
              let questCount = searchData.value?[4].datas.count else { return }
        let totalCount = monsterCount + itemCount + mapCount + npcCount + questCount
        
        searchMenus.value = [
            "전체(\(totalCount))",
            "몬스터(\(monsterCount))",
            "아이템(\(itemCount))",
            "맵(\(mapCount))",
            "NPC(\(npcCount))",
            "퀘스트(\(questCount))"
        ]
    }
}
