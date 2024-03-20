//
//  DictItemViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/01.
//

import Foundation

class DictItemViewModel: DictBaseViewModel {
    // MARK: Properties
    var tabMenus = ["아이템 정보","세부 정보","드롭 정보"]

    var selectedItem: Observable<DictItem> = Observable(nil)
    
    var dropTableContents = [DictDropContent]()

}

// MARK: Methods
extension DictItemViewModel {
    /// 아이템의 defaultValues와 subCategory 속성을 DetailContent 타입의 배열로 변경
    /// - Returns: 테이블뷰에 띄워주기 위한 DetailContent의 배열
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
    
    /// 아이템의 detailValues 속성을 DetailContent 타입의 배열로 변경
    /// - Returns: 테이블뷰에 띄워주기 위한 DetailContent의 배열
    func fetchDetailInfos() -> [DetailContent]? {
        return selectedItem.value?.detailValues.filter { $0.name != "설명" }.map { DetailContent(title: $0.name, description: $0.description) }
    }
    
    /// 아이템의 dropTable 속성을 DictDropContent 타입의 배열인 self.dropTableContents에 추가
    /// - Parameter completion: dropTableConetents를 사용하는 뷰 reload 필요 시점
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
