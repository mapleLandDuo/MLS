//
//  DictItemViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import Foundation

class DictItemViewModel {
    // MARK: Properties
    let sqliteManager = SqliteManager()
    
    var selectedTab: Observable<Int> = Observable(0)
    var tabMenus = ["아이템 정보","세부 정보","드롭 정보"]
    
    var selectedName: String?
    
    var selectedItem: Observable<DictItem> = Observable(nil)
    
    var dropTableContents = [DictDropContent]()
    
    init(selectedName: String) {
        self.selectedName = selectedName
    }
}

// MARK: Methods
extension DictItemViewModel {
    func fetchMenuIndex() -> Int {
        guard let index = selectedTab.value else { return 0 }
        return index
    }
    
    func setMenuIndex(index: Int) {
        selectedTab.value = index
    }
    
    func fetchItem() {
        guard let name = self.selectedName else { return }
        sqliteManager.searchDetailData(dataName: name) { [weak self] (item: DictItem) in
            self?.selectedItem.value = item
        }
    }
    
    func fetchDefaultInfos() -> [DetailContent]? {
        var result = selectedItem.value?.defaultValues.map { DetailContent(title: $0.name, description: $0.description) }
        if let mainCategoty = selectedItem.value?.mainCategory {
            result?.append(DetailContent(title: "주카테고리", description: mainCategoty))
        }
        if let subCategoty = selectedItem.value?.subCategory {
            result?.append(DetailContent(title: "부카테고리", description: subCategoty))
        }
        return result
    }
    
    func fetchDetailInfos() -> [DetailContent]? {
        return selectedItem.value?.detailValues.filter { $0.name != "설명" }.map { DetailContent(title: $0.name, description: $0.description) }
    }
    
    func fetchDropInfos(completion: @escaping () -> Void) {
        guard let dropTable = selectedItem.value?.dropTable else { return }
        for dropContent in dropTable {
            self.sqliteManager.searchDetailData(dataName: dropContent.name) { [weak self] (item: DictMonster) in
                guard let level = item.defaultValues.filter({ $0.name == "LEVEL" }).first?.description else { return}
                self?.dropTableContents.append(DictDropContent(name: item.name, code: item.code, level: level, description: dropContent.description))
            }
        }
        completion()
    }
}
