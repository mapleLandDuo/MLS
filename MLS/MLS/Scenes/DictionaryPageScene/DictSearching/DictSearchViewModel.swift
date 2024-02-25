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
        let manager = SqliteManager()
        manager.searchData(dataName: keyword) { (monsters:[DictMonster]) in
            self.searchData.value?[0].datas = monsters.map({DictSectionData(image: $0.code, title: $0.name, level: ":", type: .monster)})
        }
        manager.searchData(dataName: keyword) { (items:[DictItem]) in
            self.searchData.value?[1].datas = items.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .item)})
        }
        manager.searchData(dataName: keyword) { (maps:[DictMap]) in
            self.searchData.value?[2].datas = maps.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .map)})
        }
        manager.searchData(dataName: keyword) { (npcs:[DictNPC]) in
            self.searchData.value?[3].datas = npcs.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .npc)})
        }
        manager.searchData(dataName: keyword) { (quests:[DictQuest]) in
            self.searchData.value?[4].datas = quests.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .quest)})
        }
        fetchMenuData()
    }
    
    func fetchAllData() {
        let manager = SqliteManager()
        manager.fetchData() { (monsters:[DictMonster]) in
            self.searchData.value?[0].datas = monsters.map({DictSectionData(image: $0.code, title: $0.name, level: ":", type: .monster)})
        }
        manager.fetchData() { (items:[DictItem]) in
            self.searchData.value?[1].datas = items.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .item)})
        }
        manager.fetchData() { (maps:[DictMap]) in
            self.searchData.value?[2].datas = maps.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .map)})
        }
        manager.fetchData() { (npcs:[DictNPC]) in
            self.searchData.value?[3].datas = npcs.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .npc)})
        }
        manager.fetchData() { (quests:[DictQuest]) in
            self.searchData.value?[4].datas = quests.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .quest)})
        }
        fetchMenuData()
    }
    
    private func fetchMenuData() {
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
