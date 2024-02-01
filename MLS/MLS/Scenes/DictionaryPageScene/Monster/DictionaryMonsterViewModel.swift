//
//  DictionaryMonsterViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import Foundation

class DictionaryMonsterViewModel {
    // MARK: - Property

    let item: DictionaryMonster

    init(item: DictionaryMonster) {
        self.item = item
    }
}

extension DictionaryMonsterViewModel {
    // MARK: - Method

    func getItem() -> DictionaryMonster {
        return item
    }
}
