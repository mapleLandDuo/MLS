//
//  DictSearchViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 2/22/24.
//

import UIKit

import RxCocoa
import RxSwift

class DictSearchViewModel {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    let userDefaultManager = UserDefaultsManager()
    let sqlManager = SqliteManager()
    
    var isSearching = BehaviorRelay<Bool>(value: false)
    var searchKeyword = BehaviorRelay<String>(value: "")
    lazy var recentSearchKeywords = BehaviorRelay<[String]>(value: userDefaultManager.fetchRecentSearchKeyWord())
    
    var selectedMenuType = BehaviorRelay<DictMenuTypeEnum>(value: .total)
    var isShowEmptyView = BehaviorRelay(value: false)
    var isLoading = BehaviorRelay(value: false)
    
    var menuItems = BehaviorRelay(value: [
        DictMenuItem(type: .total, count: 0),
        DictMenuItem(type: .monster, count: 0),
        DictMenuItem(type: .item, count: 0),
        DictMenuItem(type: .map, count: 0),
        DictMenuItem(type: .npc, count: 0),
        DictMenuItem(type: .quest, count: 0),
    ])
    
    var dictDatas = BehaviorRelay(value: [
        DictSectionDatas(iconImage: UIImage(named: "monsterIcon"), description: "몬스터", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "itemIcon"), description: "아이템", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "mapIcon"), description: "맵", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "npcIcon"), description: "NPC", datas: []),
        DictSectionDatas(iconImage: UIImage(named: "questIcon"), description: "퀘스트", datas: [])
    ])
    
    var itemSorted = BehaviorRelay<DictSearchSortedEnum>(value: .defaultSorted)
    var monsterSorted = BehaviorRelay<DictSearchSortedEnum>(value: .defaultSorted)
    var mapSorted = BehaviorRelay<DictSearchSortedEnum>(value: .defaultSorted)
    var npcSorted = BehaviorRelay<DictSearchSortedEnum>(value: .defaultSorted)
    var questSorted = BehaviorRelay<DictSearchSortedEnum>(value: .defaultSorted)
    
    var itemFilter = BehaviorRelay<DictSearchFilter>(value: DictSearchFilter(job: nil, levelRange: nil))
    var monsterFilter = BehaviorRelay<DictSearchFilter>(value: DictSearchFilter(job: nil, levelRange: nil))
    
    init() {
        dictDatas.map({$0.map({$0.datas.count})}).subscribe { [weak self] counts in
            guard let self = self else { return }
            var temp = self.fetchMenuItems()
            temp[0].count = counts.reduce(0, +)
            temp[1].count = counts[0]
            temp[2].count = counts[1]
            temp[3].count = counts[2]
            temp[4].count = counts[3]
            temp[5].count = counts[4]
            menuItems.accept(temp)
        }.disposed(by: disposeBag)
        
        itemSorted.subscribe { [weak self] _ in
            self?.setDictDatasToSearchKeyword()
        }.disposed(by: disposeBag)
        
        monsterSorted.subscribe { [weak self] _ in
            self?.setDictDatasToSearchKeyword()
        }.disposed(by: disposeBag)
        
        npcSorted.subscribe { [weak self] _ in
            self?.setDictDatasToSearchKeyword()
        }.disposed(by: disposeBag)
        
        mapSorted.subscribe { [weak self] _ in
            self?.setDictDatasToSearchKeyword()
        }.disposed(by: disposeBag)
        
        questSorted.subscribe { [weak self] _ in
            self?.setDictDatasToSearchKeyword()
        }.disposed(by: disposeBag)
        
        itemFilter.subscribe { [weak self] _ in
            self?.setDictDatasToSearchKeyword()
        }.disposed(by: disposeBag)
        
        monsterFilter.subscribe { [weak self] _ in
            self?.setDictDatasToSearchKeyword()
        }.disposed(by: disposeBag)
    }
    
}

// MARK: - SearchingVC Methods

extension DictSearchViewModel {
    
    func setIsSearching(isSearching: Bool) {
        self.isSearching.accept(isSearching)
    }
    
    func fetchRecentSearchKeywords() -> [String] {
        return recentSearchKeywords.value
    }
    
    func selectedRecentSearchKeyword(index: Int) {
        let keywords = fetchRecentSearchKeywords()
        let keyword = keywords[index]
        appendRecentSearchKeyword(keyword: keyword)
    }
    
    func setRecentSearchKeywordToUserDefault() {
        userDefaultManager.setRecentSearchKeyWord(keyWords: recentSearchKeywords.value)
    }
    
    func didTapRecentSearchKeywordClearButton() {
        recentSearchKeywords.accept([])
    }
    
    func appendRecentSearchKeyword() {
        let keyword = searchKeyword.value
        appendRecentSearchKeyword(keyword: keyword)
    }
    
    func appendRecentSearchKeyword(keyword: String) {
        let spacingRemoveKeyword = keyword.replacingOccurrences(of: " ", with: "")
        if !spacingRemoveKeyword.isEmpty {
            let keywords = fetchRecentSearchKeywords()
            var cleanKeywords: [String] = [keyword]
            for keyword in keywords {
                if !cleanKeywords.contains(keyword) { cleanKeywords.append(keyword) }
            }
            recentSearchKeywords.accept(cleanKeywords)
            searchKeyword.accept(keyword)
        }
    }
    
    func removeRecentSearchKeyword(index: Int) {
        recentSearchKeywords.remove(index: index)
    }
}

// MARK: - SearchReseultVC Methods

extension DictSearchViewModel {
    
    func setSelectedMenuType(index: Int) {
        selectedMenuType.accept(index.convertDictMenuTypeEnum())
    }
    
    func setSelectedMenuType(rawValue: String) {
        guard let type = DictMenuTypeEnum(rawValue: rawValue) else { return }
        selectedMenuType.accept(type)
    }
    
    func fetchSelectedMenuType() -> DictMenuTypeEnum {
        return self.selectedMenuType.value
    }
    
    func fetchMenuItems() -> [DictMenuItem] {
        return menuItems.value
    }
    
    func fetchTotalDictDatas() -> [DictSectionDatas] {
        return dictDatas.value.filter({!$0.datas.isEmpty})
    }
    
    func fetchSearchKeyword() -> String {
        return searchKeyword.value
    }
    
    func fetchDictDatas(type: DictMenuTypeEnum) -> DictSectionDatas{
        switch type {
        case .monster:
            return dictDatas.value[0]
        case .item:
            return dictDatas.value[1]
        case .map:
            return dictDatas.value[2]
        case .npc:
            return dictDatas.value[3]
        case .quest:
            return dictDatas.value[4]
        case .total:
            return dictDatas.value[4]
        }
    }
    
    func setIsShowEmptyView() {
        var count = 0
        switch fetchSelectedMenuType() {
        case .total:
            count = fetchMenuItems()[0].count
        default:
            count = fetchDictDatas(type: fetchSelectedMenuType()).datas.count
        }
        if count == 0 {
            isShowEmptyView.accept(true)
        } else {
            isShowEmptyView.accept(false)
        }
    }
    
    func setSortedType(type: DictType, sortedType: DictSearchSortedEnum) {
        switch type {
        case .item:
            self.itemSorted.accept(sortedType)
        case .monster:
            self.monsterSorted.accept(sortedType)
        case .npc:
            self.npcSorted.accept(sortedType)
        case .map:
            self.mapSorted.accept(sortedType)
        case .quest:
            self.questSorted.accept(sortedType)
        }
    }
    
    func fetchSortedType(type: DictType) -> DictSearchSortedEnum {
        switch type {
        case .item:
            return self.itemSorted.value
        case .monster:
            return self.monsterSorted.value
        case .npc:
            return self.npcSorted.value
        case .map:
            return self.mapSorted.value
        case .quest:
            return self.questSorted.value
        }
    }
    
    func setFilter(type:DictType, filter: DictSearchFilter) {
        switch type {
        case .item:
            itemFilter.accept(filter)
        case .monster:
            monsterFilter.accept(filter)
        default:
            break
        }
    }
    
    func fetchFilter(type: DictType) -> DictSearchFilter {
        switch type {
        case .item:
            return itemFilter.value
        case .monster:
            return monsterFilter.value
        default:
            return DictSearchFilter()
        }
    }
    
    func setDictDatasToSearchKeyword() {
        
        let keyword = fetchSearchKeyword()
        var originDictDatas = dictDatas.value
        var monsterFilter = fetchFilter(type: .monster)
        let monsterMinLevel = monsterFilter.levelRange?.0 ?? nil
        let monsterMaxLevel = monsterFilter.levelRange?.1 ?? nil
        var itemFilter = fetchFilter(type: .item)
        let itemJobName = itemFilter.job ?? nil
        let itemMinLevel = itemFilter.levelRange?.0 ?? nil
        let itemMaxLevel = itemFilter.levelRange?.1 ?? nil
        
        isLoading.accept(true)
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.sqlManager.filterMonster(searchKeyword: keyword, minLv: monsterMinLevel, maxLv: monsterMaxLevel) { (monsters: [DictMonster]) in
                var monsters = monsters
                switch self.monsterSorted.value {
                case .defaultSorted:
                    monsters.sort { first, second in
                        return first.name < second.name
                    }
                case .highestLevel:
                    monsters.sort { first, second in
                        guard let firstNum = Int(first.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0"),
                              let secondNum = Int(second.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0") else { return true }
                        return firstNum > secondNum
                    }
                case .lowestLevel:
                    monsters.sort { first, second in
                        guard let firstNum = Int(first.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0"),
                              let secondNum = Int(second.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0") else { return true }
                        return firstNum < secondNum
                    }
                case .highestExp:
                    monsters.sort { first, second in
                        guard let firstNum = Int(first.defaultValues.filter({$0.name == "EXP"}).first?.description ?? "0"),
                              let secondNum = Int(second.defaultValues.filter({$0.name == "EXP"}).first?.description ?? "0") else { return true }
                        return firstNum > secondNum
                    }
                case .lowestExp:
                    monsters.sort { first, second in
                        guard let firstNum = Int(first.defaultValues.filter({$0.name == "EXP"}).first?.description ?? "0"),
                              let secondNum = Int(second.defaultValues.filter({$0.name == "EXP"}).first?.description ?? "0") else { return true }
                        return firstNum < secondNum
                    }
                }
                let monsterData = monsters.map({DictSectionData(image: $0.code, title: $0.name, level: ":", type: .monster)})
                originDictDatas[0].datas = monsterData
            }
            
            self.sqlManager.filterItem(searchKeyword: keyword, divisionName: nil, rollName: itemJobName, minLv: itemMinLevel, maxLv: itemMaxLevel) {(items: [DictItem]) in
                var items = items
                switch self.itemSorted.value {
                case .defaultSorted:
                    items.sort { first, second in
                        return first.name < second.name
                    }
                case .highestLevel:
                    items.sort { first, second in
                        guard let firstNum = Int(first.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0"),
                              let secondNum = Int(second.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0") else { return true }
                        return firstNum > secondNum
                    }
                case .lowestLevel:
                    items.sort { first, second in
                        guard let firstNum = Int(first.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0"),
                              let secondNum = Int(second.defaultValues.filter({$0.name == "LEVEL"}).first?.description ?? "0") else { return true }
                        return firstNum < secondNum
                    }
                default:
                    print(#function)
                }
                let itemData = items.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .item)})
                originDictDatas[1].datas = itemData
            }
            
            self.sqlManager.searchData(dataName: keyword) {(maps: [DictMap]) in
                let mapData = maps.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .map)})
                originDictDatas[2].datas = mapData
            }
            
            self.sqlManager.searchData(dataName: keyword) {(npcs: [DictNPC]) in
                let npcData = npcs.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .npc)})
                originDictDatas[3].datas = npcData
            }
            
            self.sqlManager.searchData(dataName: keyword) {(quests: [DictQuest]) in
                let questData = quests.map({DictSectionData(image: $0.code, title: $0.name, level: "", type: .quest)})
                originDictDatas[4].datas = questData
            }
            
            DispatchQueue.main.async {
                self.isLoading.accept(false)
                self.dictDatas.accept(originDictDatas)
            }
        }
    }
}
