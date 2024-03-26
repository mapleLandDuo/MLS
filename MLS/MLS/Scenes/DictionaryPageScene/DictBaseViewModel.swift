//
//  DictBaseViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/20.
//

import Foundation

import RxCocoa
import RxSwift

class DictBaseViewModel {
    let sqliteManager = SqliteManager()
    var selectedName: String?
//    var selectedTab: TempObservable<Int> = TempObservable(0)
    var selectedTab = BehaviorRelay<Int>(value: 0)
    let disposeBag = DisposeBag()
    
    init(selectedName: String) {
        self.selectedName = selectedName
    }
}

extension DictBaseViewModel {
    func fetchMenuIndex() -> Int {
//        guard let index = selectedTab.value else { return 0 }
        return selectedTab.value
    }

    func setMenuIndex(index: Int) {
        selectedTab.accept(index)
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
