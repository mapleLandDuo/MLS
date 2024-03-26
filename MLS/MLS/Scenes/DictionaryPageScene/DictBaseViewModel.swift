//
//  DictBaseViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/20.
//

import Foundation

class DictBaseViewModel {
    let sqliteManager = SqliteManager()
    var selectedName: String?
    var selectedTab: TempObservable<Int> = TempObservable(0)
    
    init(selectedName: String) {
        self.selectedName = selectedName
    }
}

extension DictBaseViewModel {
    func fetchMenuIndex() -> Int {
        guard let index = selectedTab.value else { return 0 }
        return index
    }

    func setMenuIndex(index: Int) {
        selectedTab.value = index
    }

    func fetchData<T: Sqlable>(type: DictType, completion: @escaping (T?) -> Void) {
        guard let name = selectedName else {
            completion(nil)
            return
        }
        
        sqliteManager.searchDetailData(dataName: name) { (item: T?) in
            completion(item)
        }
    }
}
