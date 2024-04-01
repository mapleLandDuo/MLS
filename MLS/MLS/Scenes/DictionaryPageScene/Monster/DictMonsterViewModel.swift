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

    var selectedMonster = BehaviorRelay<DictMonster?>(value: nil)
    var totalTextSize = BehaviorRelay<CGFloat>(value: 0.0)
    
    var didTapTagName = PublishRelay<String>()
    var didTapDropName = PublishRelay<String>()
    
    override init(selectedName: String) {
        super.init(selectedName: selectedName)
        fetchData(type: .monster, data: selectedMonster)
    }
}

// MARK: Methods
extension DictMonsterViewModel {
    func fetchDetailInfos() {
        var detailInfos = [DetailContent]()
        selectedMonster.value?.defaultValues.forEach { value in
            detailInfos.append(DetailContent(title: value.name, description: value.description)) }
        selectedMonster.value?.detailValues.forEach { value in
            detailInfos.append(DetailContent(title: value.name, description: value.description)) }
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
            if dropContent.name.contains("메소 드랍") {
                dropInfos.append(DictDropContent(name: "메소", code: "", level: dropContent.name.replacingOccurrences(of: " 드랍", with: ""), description: dropContent.description))
            }
            self.sqliteManager.searchDetailData(dataName: dropContent.name) { (item: DictItem) in
                dropInfos.append(DictDropContent(name: item.name, code: item.code, level: dropContent.name, description: dropContent.description))
            }
        }
        let section = Section(index: 1, items: [.dropItem(dropInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    func bind() {
        selectedMonster
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let monster = owner.selectedMonster.value else { return }
                owner.sectionData.updateSection(newSection: Section(index: 0, items: [.mainInfo(monster)]))
            })
            .disposed(by: disposeBag)
    }
}
