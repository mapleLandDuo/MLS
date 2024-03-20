//
//  DictSearchViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 2/22/24.
//

import UIKit

class DictSearchViewModel: DictDBViewModel {
    // MARK: - Properties
    let manager = UserDefaultsManager()
    
    lazy var recentSearchKeywords: Observable<[String]> = Observable(manager.fetchRecentSearchKeyWord())
    
    var menuItems: [DictMenuItem] = [
        DictMenuItem(type: .total, count: 0),
        DictMenuItem(type: .monster, count: 0),
        DictMenuItem(type: .item, count: 0),
        DictMenuItem(type: .map, count: 0),
        DictMenuItem(type: .npc, count: 0),
        DictMenuItem(type: .quest, count: 0),
    ]
    
    var selectedMenuType:Observable<DictMenuTypeEnum> = Observable(.total)
    
    var searchKeyword: Observable<String> = Observable("")
}

extension DictSearchViewModel {
    
    func setSelectedMenuType(index: Int) {
        selectedMenuType.value = menuItems[index].type
    }
    
    func setSelectedMenuType(rawValue: String) {
        selectedMenuType.value = DictMenuTypeEnum(rawValue: rawValue)
    }
    
    func fetchSelectedMenuType() -> DictMenuTypeEnum {
        guard let type = self.selectedMenuType.value else { return .total }
        return type
    }
    
    func fetchSelectedMenuTypeToIndex() -> Int {
        guard let type = self.selectedMenuType.value,
              let index = menuItems.firstIndex(where: { items in
                  return items.type == type
              }) else { return 0 }
        return index
    }
    
    func fetchMenuItems() -> [DictMenuItem] {
        return self.menuItems
    }
    
    func setMenuItemCount(type: DictMenuTypeEnum, count: Int) {
        guard let index = menuItems.firstIndex(where: { item in
            item.type == type
        }) else { return }
        menuItems[index].count = count
    }
    
    func fetchSearchKeyword() -> String {
        guard let keyword = self.searchKeyword.value else { return "" }
        return keyword
    }
    
    func reloadingMenuItems() {
        guard let monsterCount = searchData.value?[0].datas.count,
              let itemCount = searchData.value?[1].datas.count,
              let mapCount = searchData.value?[2].datas.count,
              let npcCount = searchData.value?[3].datas.count,
              let questCount = searchData.value?[4].datas.count else { return }
        let totalCount = monsterCount + itemCount + mapCount + npcCount + questCount
    
        setMenuItemCount(type: .total, count: totalCount)
        setMenuItemCount(type: .monster, count: monsterCount)
        setMenuItemCount(type: .item, count: itemCount)
        setMenuItemCount(type: .map, count: mapCount)
        setMenuItemCount(type: .npc, count: npcCount)
        setMenuItemCount(type: .quest, count: questCount)
    }
}
