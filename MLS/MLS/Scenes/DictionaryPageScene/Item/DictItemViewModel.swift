//
//  DictItemViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import Foundation

import RxCocoa
import RxDataSources

class DictItemViewModel: DictBaseViewModel {
    // MARK: Properties
    var tabMenus = ["아이템 정보", "세부 정보", "드롭 정보"]

    var selectedItem = BehaviorRelay<DictItem?>(value: nil)

    var sectionData = BehaviorRelay<[Section]>(value: [])
    
    var tappedCellName = PublishRelay<String>()

    override init(selectedName: String) {
        super.init(selectedName: selectedName)
        fetchData(type: .item) { [weak self] (item: DictItem?) in
            self?.selectedItem.accept(item)
            self?.bind()
        }
    }
}

// MARK: Methods
extension DictItemViewModel {
    /// 아이템의 defaultValues와 subCategory 속성을 DetailContent 타입의 배열로 변경
    /// - Returns: 테이블뷰에 띄워주기 위한 DetailContent의 배열
    func fetchDefaultInfos() {
        var defaultInfo = [DetailContent]()
        selectedItem.value?.defaultValues.forEach { value in defaultInfo.append((DetailContent(title: value.name, description: value.description))) }
        if let mainCategoty = selectedItem.value?.mainCategory {
            defaultInfo.append(DetailContent(title: "주카테고리", description: mainCategoty))
        }
        if let subCategoty = selectedItem.value?.subCategory {
            defaultInfo.append(DetailContent(title: "부카테고리", description: subCategoty))
        }
        let section = Section(index: 1, items: [.detailInfo(defaultInfo)])
        sectionData.updateSection(newSection: section)
    }

    /// 아이템의 detailValues 속성을 DetailContent 타입의 배열로 변경
    /// - Returns: 테이블뷰에 띄워주기 위한 DetailContent의 배열
    func fetchDetailInfos() {
        var detailInfo = [DetailContent]()
        selectedItem.value?.detailValues.filter { $0.name != "설명" }.forEach { value in
            detailInfo.append(DetailContent(title: value.name, description: value.description)) }
        let section = Section(index: 1, items: [.detailInfo(detailInfo)])
        sectionData.updateSection(newSection: section)
    }

    /// 아이템의 dropTable 속성을 DictDropContent 타입의 배열인 self.dropTableContents에 추가
    /// - Parameter completion: dropTableConetents를 사용하는 뷰 reload 필요 시점
    func fetchDropInfos() {
        var dropInfo = [DictDropContent]()
        guard let dropTable = selectedItem.value?.dropTable else { return }
        for dropContent in dropTable {
            sqliteManager.searchDetailData(dataName: dropContent.name) { (item: DictMonster) in
                guard let level = item.defaultValues.filter({ $0.name == "LEVEL" }).first?.description else { return }
                dropInfo.append(DictDropContent(name: item.name, code: item.code, level: level, description: dropContent.description))
            }
        }
        let section = Section(index: 1, items: [.dropItem(dropInfo)])
        sectionData.updateSection(newSection: section)
    }

    func bind() {
        selectedItem
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let item = owner.selectedItem.value else { return }
                owner.sectionData.updateSection(newSection: Section(index: 0, items: [.mainInfo(item)]))
            })
            .disposed(by: disposeBag)
    }
}

struct Section {
    var index: Int
    var items: [SectionItem]
}

enum SectionItem {
    case mainInfo(DictItem)
    case detailInfo([DetailContent])
    case dropItem([DictDropContent])
}

extension Section: SectionModelType {
    typealias Item = SectionItem

    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}
