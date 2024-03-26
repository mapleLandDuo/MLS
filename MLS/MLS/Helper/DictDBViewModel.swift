//
//  DictDBViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 3/20/24.
//

import UIKit

class DictDBViewModel {
    
    // MARK: - Properties
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
    
    let searchData: TempObservable<[DictSectionDatas]> = TempObservable([
        DictSectionDatas(iconImage: UIImage(named: "monsterIcon"), description: "몬스터", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "itemIcon"), description: "아이템", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "mapIcon"), description: "맵", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "npcIcon"), description: "NPC", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "questIcon"), description: "퀘스트", datas: [])
    ])
    
    var itemSorted: DictSearchSortedEnum = .defaultSorted
    var monsterSorted: DictSearchSortedEnum = .defaultSorted
    var mapSorted: DictSearchSortedEnum = .defaultSorted
    var npcSorted: DictSearchSortedEnum = .defaultSorted
    var questSorted: DictSearchSortedEnum = .defaultSorted
    
    var itemFilter: DictSearchFilter = DictSearchFilter(job: nil, levelRange: nil)
    var monsterFilter: DictSearchFilter = DictSearchFilter(job: nil, levelRange: nil)
}

// MARK: - Methods
extension DictDBViewModel {
    
    func setOriginData(keyword: String) {
        
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
    
    func setOriginDataToAllData() {
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
    
    func setFilterDataToOriginData() {
        filterMonsterData = originMonsterData
        filterItemData = originItemData
        filterMapData = originMapData
        filterNpcData = originNpcData
        filterQuestData = originQuestData
        filterDataSorted()
    }
    
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
    
    func fetchTotalSearchData() -> [DictSectionDatas] {
        guard let datas = searchData.value?.filter({!$0.datas.isEmpty}) else { return [] }
        return datas
    }
    
    func fetchSearchData(type: DictMenuTypeEnum) -> DictSectionDatas {
        let data = DictSectionDatas(iconImage: nil, description: "", datas: [])
        guard let index = searchData.value?.firstIndex(where: { data in data.description == type.rawValue }),
              let data = searchData.value?[index] else { return data }
        return data
    }
    
    func setSearchDataToFilterData() {
        self.searchData.value?[0].datas = filterMonsterData.map({DictSectionData(image: $0.code, title: $0.name, level: ":", type: .monster)})
        self.searchData.value?[1].datas = filterItemData.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .item)})
        self.searchData.value?[2].datas = filterMapData.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .map)})
        self.searchData.value?[3].datas = filterNpcData.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .npc)})
        self.searchData.value?[4].datas = filterQuestData.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .quest)})
    }
    
    func resetFilter() {
        itemFilter = DictSearchFilter()
        monsterFilter = DictSearchFilter()
    }
}

// MARK: - SortedMethods
extension DictDBViewModel {
    
    func fetchSortedEnum(type: DictMenuTypeEnum) -> DictSearchSortedEnum {
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
        case .total:
            return .defaultSorted
        }
    }
    
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
