//
//  DictMonsterViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import Foundation

import RxCocoa

class DictMonsterViewModel: DictBaseViewModel {
    // MARK: Properties
    var tabMenus = ["몬스터 정보","출현 장소","드롭 정보"]

//    var selectedMonster: TempObservable<DictMonster> = TempObservable(nil)
    var selectedMonster = BehaviorRelay<DictMonster?>(value: nil)
    
    var dropTableContents = [DictDropContent]()
    
//    var totalTextSize: TempObservable<CGFloat> = TempObservable(0.0)
    var totalTextSize = BehaviorRelay<CGFloat>(value: 0.0)
}

// MARK: Methods
extension DictMonsterViewModel {
    func fetchDetailInfos() -> [DetailContent]? {
        var result = [DetailContent]()
        result = selectedMonster.value?.defaultValues.map { DetailContent(title: $0.name, description: $0.description) } ?? []
        result += selectedMonster.value?.detailValues.map { DetailContent(title: $0.name, description: $0.description) } ?? []
        return result
    }
    
    func fetchDropInfos(completion: @escaping () -> Void) {
        guard let dropTable = selectedMonster.value?.dropTable else { return }
        for dropContent in dropTable {
            if dropContent.name.contains("메소 드랍") {
                self.dropTableContents.append(DictDropContent(name: "메소", code: "", level: dropContent.name.replacingOccurrences(of: " 드랍", with: ""), description: dropContent.description))
            }
            self.sqliteManager.searchDetailData(dataName: dropContent.name) { [weak self] (item: DictItem) in
                self?.dropTableContents.append(DictDropContent(name: item.name, code: item.code, level: dropContent.name, description: dropContent.description))
            }
        }
        completion()
    }
}
