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
//    let manager = UserDefaultsManager()
//    
//    lazy var recentSearchKeywords: TempObservable<[String]> = TempObservable(manager.fetchRecentSearchKeyWord())
//    
//    var menuItems: [DictMenuItem] = [
//        DictMenuItem(type: .total, count: 0),
//        DictMenuItem(type: .monster, count: 0),
//        DictMenuItem(type: .item, count: 0),
//        DictMenuItem(type: .map, count: 0),
//        DictMenuItem(type: .npc, count: 0),
//        DictMenuItem(type: .quest, count: 0),
//    ]
//    
//    var selectedMenuType:TempObservable<DictMenuTypeEnum> = TempObservable(.total)
//    
//    var searchKeyword: TempObservable<String> = TempObservable("")
    
    // MARK: - Refactor Properties
    let userDefaultManager = UserDefaultsManager()
    
    var isSearching = BehaviorRelay<Bool>(value: false)
    var searchKeyword = BehaviorRelay<String>(value: "")
    lazy var recentSearchKeywords = BehaviorRelay<[String]>(value: userDefaultManager.fetchRecentSearchKeyWord())

}

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
    
    
//    func setSelectedMenuType(index: Int) {
//        selectedMenuType.value = menuItems[index].type
//    }
//    
//    func setSelectedMenuType(rawValue: String) {
//        selectedMenuType.value = DictMenuTypeEnum(rawValue: rawValue)
//    }
//    
//    func fetchSelectedMenuType() -> DictMenuTypeEnum {
//        guard let type = self.selectedMenuType.value else { return .total }
//        return type
//    }
//    
//    func fetchSelectedMenuTypeToIndex() -> Int {
//        guard let type = self.selectedMenuType.value,
//              let index = menuItems.firstIndex(where: { items in
//                  return items.type == type
//              }) else { return 0 }
//        return index
//    }
//    
//    func fetchMenuItems() -> [DictMenuItem] {
//        return self.menuItems
//    }
//    
//    func setMenuItemCount(type: DictMenuTypeEnum, count: Int) {
//        guard let index = menuItems.firstIndex(where: { item in
//            item.type == type
//        }) else { return }
//        menuItems[index].count = count
//    }
//    
//    func fetchSearchKeyword() -> String {
//        guard let keyword = self.searchKeyword.value else { return "" }
//        return keyword
//    }
//    
//    func reloadingMenuItems() {
//        guard let monsterCount = searchData.value?[0].datas.count,
//              let itemCount = searchData.value?[1].datas.count,
//              let mapCount = searchData.value?[2].datas.count,
//              let npcCount = searchData.value?[3].datas.count,
//              let questCount = searchData.value?[4].datas.count else { return }
//        let totalCount = monsterCount + itemCount + mapCount + npcCount + questCount
//    
//        setMenuItemCount(type: .total, count: totalCount)
//        setMenuItemCount(type: .monster, count: monsterCount)
//        setMenuItemCount(type: .item, count: itemCount)
//        setMenuItemCount(type: .map, count: mapCount)
//        setMenuItemCount(type: .npc, count: npcCount)
//        setMenuItemCount(type: .quest, count: questCount)
//    }
}
