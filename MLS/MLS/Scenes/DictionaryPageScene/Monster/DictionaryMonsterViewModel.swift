//
//  DictionaryMonsterViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import Foundation

class DictionaryMonsterViewModel {
    // MARK: - Properties

    let item: DictionaryMonster

    init(item: DictionaryMonster) {
        self.item = item
    }
}

// MARK: - Method
extension DictionaryMonsterViewModel {

    func getItem() -> DictionaryMonster {
        return item
    }
}
