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
    
    var selectedType: DictType?
    
    var selectedTab = BehaviorRelay<Int>(value: 0)
    var mainInfo = BehaviorRelay<DictEntity?>(value: nil)
    var sectionData = BehaviorRelay<[Section]>(value: [])
    
    var tabMenus = BehaviorRelay<[String]>(value: [])
    
    let disposeBag = DisposeBag()
    
    init(selectedName: String, type: DictType) {
        self.selectedType = type
        self.selectedName = selectedName
        setTabMenus(type: type)
    }
}

extension DictBaseViewModel {
    func fetchMenuIndex() -> Int {
        return selectedTab.value
    }

    func fetchData<T: DictEntity>(type: DictType, data: BehaviorRelay<T?>) {
        guard let name = selectedName else {
            return
        }
        
        sqliteManager.searchDetailData(dataName: name) { [weak self] (item: T?) in
            data.accept(item)
            self?.bind(data: data)
            
        }
    }
    
    private func bind<T: DictEntity>(data: BehaviorRelay<T?>) {
        data
            .compactMap{ $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.sectionData.updateSection(newSection: Section(index: 0, items: [.mainInfo(value)]))
            })
            .disposed(by: disposeBag)
    }
    
    private func setTabMenus(type: DictType) {
        switch type {
        case .item:
            tabMenus.accept(["아이템 정보", "세부 정보", "드롭 정보"])
        case .monster:
            tabMenus.accept(["몬스터 정보","출현 장소","드롭 정보"])
        case .map:
            tabMenus.accept(["출현 몬스터","NPC"])
        case .npc:
            tabMenus.accept(["출현 장소", "수락 퀘스트"])
        case .quest:
            tabMenus.accept(["정보 & 완료조건","퀘스트 보상","퀘스트 순서"])
        }
    }
}
