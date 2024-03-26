//
//  PopularViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/04.
//

import Foundation

class PopularViewModel {
    // MARK: Properties
    var selectedTab: TempObservable<Int> = TempObservable(0)
    var tabMenus = ["인기 아이템", "인기 몬스터"]
    
    let datas: TempObservable<[DictSectionDatas]> = TempObservable(nil)
    
    let title: TempObservable<String> = TempObservable(nil)
    
    init(datas: [DictSectionDatas], title: String?) {
        self.datas.value = datas
        self.title.value = title
    }
}

// MARK: Methods
extension PopularViewModel {
    func fetchMenuIndex() -> Int {
        guard let index = selectedTab.value else { return 0 }
        return index
    }
    
    func setMenuIndex(index: Int) {
        selectedTab.value = index
    }
}
