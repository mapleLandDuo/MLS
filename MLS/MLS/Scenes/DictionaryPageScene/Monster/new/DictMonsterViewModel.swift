//
//  DictMonsterViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import Foundation

class DictMonsterViewModel {
    // MARK: Properties
    let sqliteManager = SqliteManager()
    
    var selectedTab: Observable<Int> = Observable(0)
    var tabMenus = ["몬스터 정보","출현 장소","드롭 정보"]
    
    var selectedName: String?
    
    var selectedMonster: Observable<DictMonster> = Observable(nil)
    
    var dropTableContents = [DictDropContent]()
    
    init(selectedName: String) {
        self.selectedName = selectedName
    }
}

// MARK: Methods
extension DictMonsterViewModel {
    func fetchMenuIndex() -> Int {
        guard let index = selectedTab.value else { return 0 }
        return index
    }
    
    func setMenuIndex(index: Int) {
        selectedTab.value = index
    }
    
    func fetchItem() {
        guard let name = self.selectedName else { return }
        sqliteManager.searchDetailData(dataName: name) { [weak self] (item: DictMonster) in
            self?.selectedMonster.value = item
        }
    }
    
    func fetchDetailInfos() -> [DetailContent]? {
        var result = [DetailContent]()
        result = selectedMonster.value?.defaultValues.map { DetailContent(title: $0.name, description: $0.description) } ?? []
        result += selectedMonster.value?.detailValues.map { DetailContent(title: $0.name, description: $0.description) } ?? []
        return result
    }
    
    func fetchDropInfos(completion: @escaping () -> Void) {
        guard let dropTable = selectedMonster.value?.dropTable else { return }
        for dropContent in dropTable {
            self.sqliteManager.searchDetailData(dataName: dropContent.name) { [weak self] (item: DictMonster) in
                guard let level = item.defaultValues.filter({ $0.name == "LEVEL" }).first?.description else { return}
                self?.dropTableContents.append(DictDropContent(name: item.name, code: item.code, level: level, description: dropContent.description))
            }
        }
        completion()
    }
}
