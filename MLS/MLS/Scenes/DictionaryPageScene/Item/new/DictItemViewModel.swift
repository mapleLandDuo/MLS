//
//  DictItemViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import Foundation

class DictItemViewModel {
    // MARK: Properties
    var selectedTab: Observable<Int> = Observable(0)
    var tabMenus = ["아이템 정보","세부 정보","드롭 정보"]
    
    let selectedMenuIndex: Observable<Int> = Observable(0)
}

// MARK: Methods
extension DictItemViewModel {
    func fetchMenuIndex() -> Int {
        guard let index = selectedMenuIndex.value else { return 0 }
        return index
    }
}
