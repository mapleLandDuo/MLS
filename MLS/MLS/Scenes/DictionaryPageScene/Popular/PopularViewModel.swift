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
    var tabMenus = BehaviorRelay<[String]>(value: ["인기 아이템", "인기 몬스터"])
    
    var selectedTab = BehaviorRelay<Int>(value: 0)
    let datas = BehaviorRelay<[DictSectionDatas]?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let disposeBag = DisposeBag()
    
    let selectedData = BehaviorSubject<[DictSectionData]>(value: [])
    
    init(datas: [DictSectionDatas], title: String?) {
        self.datas.accept(datas)
        self.title.accept(title)
        bind()
    }
}

// MARK: Methods
extension PopularViewModel {
    func fetchMenuIndex() -> Int {
        return selectedTab.value
    }
    
    func setMenuIndex(index: Int) {
        selectedTab.accept(index)
    }
    
    func bind() {
        selectedTab
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedTab in
                if selectedTab == 0 {
                    if let datas = owner.datas.value?[0].datas {
                        owner.selectedData.onNext(datas)
                    }
                } else {
                    if let datas = owner.datas.value?[1].datas {
                        owner.selectedData.onNext(datas)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
