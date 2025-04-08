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
    var selectedMonster = BehaviorRelay<DictMonster?>(value: nil)
    var totalTextSize = BehaviorRelay<CGFloat>(value: 0.0)
    
    var tappedTagName = PublishRelay<String>()
    var tappedDropName = PublishRelay<String>()
    var tappedExpandButton = PublishRelay<Bool>()
    
    override init(selectedName: String, type: DictType) {
        super.init(selectedName: selectedName, type: type)
        fetchData(type: type, data: selectedMonster)
        checkEmptyData()
    }
}

// MARK: Methods
extension DictMonsterViewModel {
    func fetchDetailInfos() {
        var detailInfos = [DetailContent]()
        selectedMonster.value?.defaultValues.forEach { value in
            detailInfos.append(DetailContent(title: value.title, description: value.description)) }
        selectedMonster.value?.detailValues.forEach { value in
            detailInfos.append(DetailContent(title: value.title, description: value.description)) }
        let section = Section(index: 1, items: [.detailInfo(detailInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    func fetchTagInfos() {
        guard let tagInfos = selectedMonster.value?.hauntArea else { return }
        let section = Section(index: 1, items: [.tagInfo(tagInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    func fetchDropInfos() {
        var dropInfos = [DictDropContent]()
        guard let dropTable = selectedMonster.value?.dropTable else { return }
        for dropContent in dropTable {
            if dropContent.title.contains("메소 드랍") {
                dropInfos.append(DictDropContent(title: "메소", code: "", level: dropContent.title.replacingOccurrences(of: " 드랍", with: ""), description: dropContent.description))
            }
            self.sqliteManager.searchDetailData(dataName: dropContent.title) { (item: DictItem) in
                dropInfos.append(DictDropContent(title: item.name, code: item.code, level: dropContent.title, description: dropContent.description))
            }
        }
        let section = Section(index: 1, items: [.dropItem(dropInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    func checkEmptyData() {
        if let value = selectedMonster.value {
            if value.defaultValues.isEmpty {
                emptyData.append(0)
            }
            if value.hauntArea.isEmpty {
                emptyData.append(1)
            }
            if value.dropTable.isEmpty {
                emptyData.append(2)
            }
        }
    }
}
