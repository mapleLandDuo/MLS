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
    var searchMenus = ["전체(0)","몬스터(0)","아이템(0)","맵(0)","NPC(0)","퀘스트(0)"]
    var searchKeyword: String = ""
    
    var originMonsterData: [DictMonster] = []
    var originItemData: [DictItem] = []
    var originMapData: [DictMap] = []
    var originNpcData: [DictNPC] = []
    var originQuestData: [DictQuest] = []
    
    var filterMonsterData: [DictMonster] = []
    var filterItemData: [DictItem] = []
    var filterMapData: [DictMap] = []
    var filterNpcData: [DictNPC] = []
    var filterQuestData: [DictQuest] = []
    
    let searchData: Observable<[DictSectionDatas]> = Observable([
        DictSectionDatas(iconImage: UIImage(named: "monsterIcon"), description: "몬스터", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "itemIcon"), description: "아이템", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "mapIcon"), description: "맵", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "npcIcon"), description: "NPC", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "questIcon"), description: "퀘스트", datas: [])
    ])
    
    let selectedMenuIndex: Observable<Int> = Observable(0)
    
    var itemSorted: DictSearchSortedEnum = .defaultSorted
    var monsterSorted: DictSearchSortedEnum = .defaultSorted
    var mapSorted: DictSearchSortedEnum = .defaultSorted
    var npcSorted: DictSearchSortedEnum = .defaultSorted
    var questSorted: DictSearchSortedEnum = .defaultSorted
    
    var itemFilter: DictSearchFilter = DictSearchFilter(job: nil, levelRange: nil)
    var monsterFilter: DictSearchFilter = DictSearchFilter(job: nil, levelRange: nil)
    
}

extension DictSearchViewModel {
    
    func setFilterData(type: DictType, datas: [Any]) {
        switch type {
        case .monster:
            guard let datas = datas as? [DictMonster] else { return }
            filterMonsterData = datas
        case .item:
            guard let datas = datas as? [DictItem] else { return }
            filterItemData = datas
        case .map:
            guard let datas = datas as? [DictMap] else { return }
            filterMapData = datas
        case .npc:
            guard let datas = datas as? [DictNPC] else { return }
            filterNpcData = datas
        case .quest:
            guard let datas = datas as? [DictQuest] else { return }
            filterQuestData = datas
        }
        filterDataSorted()
    }
    
    func fetchSearchData() -> [DictSectionDatas] {
        guard let data = searchData.value else { return [] }
        return data
    }
    
    func fetchMenuIndex() -> Int {
        guard let index = selectedMenuIndex.value else { return 0 }
        return index
    }
    
    func setMenuIndex(index: Int) {
        selectedMenuIndex.value = index
    }
    
    func fetchSearchData(keyword: String) {
        
        let manager = SqliteManager()
        manager.searchData(dataName: keyword) { [weak self] (monsters: [DictMonster]) in
            self?.originMonsterData = monsters
        }
        manager.searchData(dataName: keyword) { [weak self] (items: [DictItem]) in
            self?.originItemData = items
        }
        manager.searchData(dataName: keyword) { [weak self] (maps: [DictMap]) in
            self?.originMapData = maps
        }
        manager.searchData(dataName: keyword) { [weak self] (npcs: [DictNPC]) in
            self?.originNpcData = npcs
        }
        manager.searchData(dataName: keyword) { [weak self] (quests: [DictQuest]) in
            self?.originQuestData = quests
        }
        
        setFilterDataToOriginData()
    }
    
    func fetchAllSearchData() {
        let manager = SqliteManager()
        manager.fetchData() { [weak self] (monsters: [DictMonster]) in
            self?.originMonsterData = monsters
        }
        manager.fetchData() { [weak self] (items: [DictItem]) in
            self?.originItemData = items
        }
        manager.fetchData() { [weak self] (maps: [DictMap]) in
            self?.originMapData = maps
        }
        manager.fetchData() { [weak self] (npcs: [DictNPC]) in
            self?.originNpcData = npcs
        }
        manager.fetchData() { [weak self] (quests: [DictQuest]) in
            self?.originQuestData = quests
        }
        setFilterDataToOriginData()
    }
    
    func setSearchDataToFilterData() {
        self.searchData.value?[0].datas = filterMonsterData.map({DictSectionData(image: $0.code, title: $0.name, level: ":", type: .monster)})
        self.searchData.value?[1].datas = filterItemData.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .item)})
        self.searchData.value?[2].datas = filterMapData.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .map)})
        self.searchData.value?[3].datas = filterNpcData.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .npc)})
        self.searchData.value?[4].datas = filterQuestData.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .quest)})
        fetchMenuData()
    }
    
    func setFilterDataToOriginData() {
        filterMonsterData = originMonsterData
        filterItemData = originItemData
        filterMapData = originMapData
        filterNpcData = originNpcData
        filterQuestData = originQuestData
        filterDataSorted()
    }
    
    private func fetchMenuData() {
        guard let monsterCount = searchData.value?[0].datas.count,
              let itemCount = searchData.value?[1].datas.count,
              let mapCount = searchData.value?[2].datas.count,
              let npcCount = searchData.value?[3].datas.count,
              let questCount = searchData.value?[4].datas.count else { return }
        let totalCount = monsterCount + itemCount + mapCount + npcCount + questCount
        
        searchMenus = [
            "전체(\(totalCount))",
            "몬스터(\(monsterCount))",
            "아이템(\(itemCount))",
            "맵(\(mapCount))",
            "NPC(\(npcCount))",
            "퀘스트(\(questCount))"
        ]
    }
}

// MARK: - SortedMethods
extension DictSearchViewModel {
    
    func fetchSortedEnum(type: DictType) -> DictSearchSortedEnum {
        switch type {
        case .item:
            return itemSorted
        case .monster:
            return monsterSorted
        case .npc:
            return mapSorted
        case .map:
            return npcSorted
        case .quest:
            return questSorted
        }
    }
    
    func setSortedEnum(type: DictType, sorted: DictSearchSortedEnum) {
        switch type {
        case .item:
            itemSorted = sorted
        case .monster:
            monsterSorted = sorted
        case .npc:
            npcSorted = sorted
        case .map:
            mapSorted = sorted
        case .quest:
            questSorted = sorted
        }
        filterDataSorted()
    }
    
    func filterDataSorted() {
        
        switch monsterSorted {
        case .defaultSorted:
            filterMonsterData.sort { first, second in
                return first.name < second.name
            }
        case .highestLevel:
            filterMonsterData.sort { first, second in
                guard let firstNum = Int(first.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0"),
                      let secondNum = Int(second.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0") else { return true }
                return firstNum > secondNum
            }
        case .lowestLevel:
            filterMonsterData.sort { first, second in
                guard let firstNum = Int(first.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0"),
                      let secondNum = Int(second.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0") else { return true }
                return firstNum < secondNum
            }
        case .highestExp:
            filterMonsterData.sort { first, second in
                guard let firstNum = Int(first.defaultValues.filter({$0.name == "EXP"}).first?.description ?? "0"),
                      let secondNum = Int(second.defaultValues.filter({$0.name == "EXP"}).first?.description ?? "0") else { return true }
                return firstNum > secondNum
            }
        case .lowestExp:
            filterMonsterData.sort { first, second in
                guard let firstNum = Int(first.defaultValues.filter({$0.name == "EXP"}).first?.description ?? "0"),
                      let secondNum = Int(second.defaultValues.filter({$0.name == "EXP"}).first?.description ?? "0") else { return true }
                return firstNum < secondNum
            }
        default :
            print(#function)
        }
        switch itemSorted {
        case .defaultSorted:
            filterItemData.sort { first, second in
                return first.name < second.name
            }
        case .highestLevel:
            filterItemData.sort { first, second in
                guard let firstNum = Int(first.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0"),
                      let secondNum = Int(second.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0") else { return true }
                return firstNum > secondNum
            }
        case .lowestLevel:
            filterItemData.sort { first, second in
                guard let firstNum = Int(first.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0"),
                      let secondNum = Int(second.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0") else { return true }
                return firstNum < secondNum
            }
        default:
            print(#function)
        }
        setSearchDataToFilterData()
    }
}
