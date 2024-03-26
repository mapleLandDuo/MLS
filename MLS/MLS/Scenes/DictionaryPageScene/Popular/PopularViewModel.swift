//
//  PopularViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/04.
//

import Foundation

import RxCocoa
import RxSwift

class PopularViewModel {
    // MARK: Properties
//    var selectedTab: TempObservable<Int> = TempObservable(0)
    var selectedTab = BehaviorRelay<Int>(value: 0)
    var tabMenus = ["인기 아이템", "인기 몬스터"]
    
//    let datas: TempObservable<[DictSectionDatas]> = TempObservable(nil)
    let datas = BehaviorRelay<[DictSectionDatas]?>(value: nil)
    
//    let title: TempObservable<String> = TempObservable(nil)
    let title = BehaviorRelay<String?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    init(datas: [DictSectionDatas], title: String?) {
        self.datas.accept(datas)
        self.title.accept(title)
    }
}

// MARK: Methods
extension PopularViewModel {
    func fetchMenuIndex() -> Int {
//        guard let index = selectedTab.value else { return 0 }
        return selectedTab.value
    }
    
    func setMenuIndex(index: Int) {
        selectedTab.accept(index)
    }
}
