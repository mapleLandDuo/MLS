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
//    var tabMenus = ["아이템 정보", "세부 정보", "드롭 정보"]
    var tabMenus = BehaviorRelay<[String]>(value: ["아이템 정보", "세부 정보", "드롭 정보"])

    var selectedItem = BehaviorRelay<DictItem?>(value: nil)

    var tappedCellName = PublishRelay<String>()
    var tappedExpandButton = PublishRelay<Bool>()

    override init(selectedName: String) {
        super.init(selectedName: selectedName)
        fetchData(type: .item, data: selectedItem)
        checkEmptyData()
    }
}

// MARK: Methods
extension DictItemViewModel {
    /// 아이템의 defaultValues와 subCategory 속성을 DetailContent 타입의 배열로 변경
    /// - Returns: 테이블뷰에 띄워주기 위한 DetailContent의 배열
    func fetchDefaultInfos() {
        var defaultInfos = [DetailContent]()
        selectedItem.value?.defaultValues.forEach { value in defaultInfos.append(DetailContent(title: value.name, description: value.description)) }
        if let mainCategoty = selectedItem.value?.mainCategory {
            defaultInfos.append(DetailContent(title: "주카테고리", description: mainCategoty))
        }
        if let subCategoty = selectedItem.value?.subCategory {
            defaultInfos.append(DetailContent(title: "부카테고리", description: subCategoty))
        }
        let section = Section(index: 1, items: [.detailInfo(defaultInfos)])
        sectionData.updateSection(newSection: section)
    }

    /// 아이템의 detailValues 속성을 DetailContent 타입의 배열로 변경
    /// - Returns: 테이블뷰에 띄워주기 위한 DetailContent의 배열
    func fetchDetailInfos() {
        var detailInfos = [DetailContent]()
        selectedItem.value?.detailValues.filter { $0.name != "설명" }.forEach {
            detailInfos.append(DetailContent(title: $0.name, description: $0.description))
        }
        let section = Section(index: 1, items: [.detailInfo(detailInfos)])
        sectionData.updateSection(newSection: section)
    }

    /// 아이템의 dropTable 속성을 DictDropContent 타입의 배열인 self.dropTableContents에 추가
    /// - Parameter completion: dropTableConetents를 사용하는 뷰 reload 필요 시점
    func fetchDropInfos() {
        var dropInfos = [DictDropContent]()
        guard let dropTable = selectedItem.value?.dropTable else { return }
        for dropContent in dropTable {
            sqliteManager.searchDetailData(dataName: dropContent.name) { (item: DictMonster) in
                guard let level = item.defaultValues.filter({ $0.name == "LEVEL" }).first?.description else { return }
                dropInfos.append(DictDropContent(name: item.name, code: item.code, level: level, description: dropContent.description))
            }
        }
        let section = Section(index: 1, items: [.dropItem(dropInfos)])
        sectionData.updateSection(newSection: section)
    }

    func checkEmptyData() {
        if let value = selectedItem.value {
            if value.defaultValues.isEmpty {
                emptyData.append(0)
            }
            if value.detailValues.isEmpty {
                emptyData.append(1)
            }
            if value.dropTable.isEmpty {
                emptyData.append(2)
            }
        }
    }
}

struct Section {
    var index: Int
    var items: [SectionItem]
}

enum SectionItem {
    case mainInfo(DictEntity)
    case detailInfo([DetailContent])
    case tagInfo([String])
    case dropItem([DictDropContent])
}

extension Section: SectionModelType {
    typealias Item = SectionItem

    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}
