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
    var emptyData = [Int]()
    
    var selectedTab = BehaviorRelay<Int>(value: 0)
    var mainInfo = BehaviorRelay<Sqlable?>(value: nil)
    var sectionData = BehaviorRelay<[Section]>(value: [])
    
    let disposeBag = DisposeBag()
    
    init(selectedName: String) {
        self.selectedName = selectedName
    }
}

extension DictBaseViewModel {
    func fetchMenuIndex() -> Int {
        return selectedTab.value
    }

    func fetchData<T: Sqlable>(type: DictType, data: BehaviorRelay<T?>) {
        guard let name = selectedName else {
            return
        }
        
        sqliteManager.searchDetailData(dataName: name) { [weak self] (item: T?) in
            data.accept(item)
            self?.bind(data: data)
            
        }
    }
    
    func bind<T: Sqlable>(data: BehaviorRelay<T?>) {
        data
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let value = data.value else { return }
                owner.sectionData.updateSection(newSection: Section(index: 0, items: [.mainInfo(value)]))
            })
            .disposed(by: disposeBag)
    }
}
