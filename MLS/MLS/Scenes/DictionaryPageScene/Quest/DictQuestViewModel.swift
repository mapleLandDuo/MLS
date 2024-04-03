//
//  DictQuestViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import Foundation

import RxCocoa

class DictQuestViewModel: DictBaseViewModel {
    // MARK: Properties
    var tabMenus = ["정보 & 완료조건","퀘스트 보상","퀘스트 순서"]
    
    var selectedQuest = BehaviorRelay<DictQuest?>(value: nil)
    
    var tappedCellData = PublishRelay<(String, DictType)>()
    var tappedCellQuest = PublishRelay<String>()
    var tappedExpandButton = PublishRelay<Bool>()
    
    override init(selectedName: String) {
        super.init(selectedName: selectedName)
        fetchData(type: .quest, data: selectedQuest)
        checkEmptyData()
    }
}

// MARK: Methods
extension DictQuestViewModel {
    /// 퀘스트의 반복회수와 defaultValues 속성을 DetailContent 타입의 배열로 변경
    /// - Returns: 뷰에 뿌려질 DetailConetent 타입의 배열
    func fetchDefaultInfos(){
        var defaultInfos = [DetailContent]()
        guard let times = selectedQuest.value?.times else { return }
        defaultInfos.append(DetailContent(title: "반복", description: times))
        selectedQuest.value?.defaultValues.forEach { value in defaultInfos.append(DetailContent(title: value.name, description: value.description)) }
        let section = Section(index: 1, items: [.detailInfo(defaultInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    /// 퀘스트의 완료조건을 DictDropContent타입의 배열인 self.completeTableContents에 저장
    /// - Parameter completion: completeTableContents를 사용하는 뷰 reload 필요 시점
    func fetchCompleteInfos() {
        var completionInfos = [DictDropContent]()
        guard let completions = selectedQuest.value?.toCompletion else { return }
        for completion in completions {
            if completion.description.contains("전달") {
                self.sqliteManager.searchDetailData(dataName: completion.name) { (item: DictItem) in
                    completionInfos.append(DictDropContent(name: item.name, code: item.code, level: "", description: completion.description))
                }
            } else {
                self.sqliteManager.searchDetailData(dataName: completion.name) { (item: DictMonster) in
                   completionInfos.append(DictDropContent(name: item.name, code: item.code, level: "", description: completion.description))
                }
            }
        }
        let section = Section(index: 2, items: [.dropItem(completionInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    /// 퀘스트 보상정보의 텍스트정보를 DetailContent타입의 배열로 변경
    /// - Returns: 변경된 DetailConetnt 배열
    func fetchRewardTableContents() {
        var rewardInfos = [DetailContent]()
        selectedQuest.value.map {
            if let meso = $0.reward.first(where: { $0.name == "메소" })?.description {
                rewardInfos.append(DetailContent(title: "메소", description: meso))
            }
        }
        selectedQuest.value.map {
            if let exp = $0.reward.first(where: { $0.name == "경험치" })?.description {
                rewardInfos.append(DetailContent(title: "경험치", description: exp))
            }
        }
        selectedQuest.value.map {
            if let popularity = $0.reward.first(where: { $0.name == "인기도" })?.description {
                rewardInfos.append(DetailContent(title: "인기도", description: popularity))
            }
        }
        let section = Section(index: 1, items: [.detailInfo(rewardInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    /// 퀘스트 보상정보의 아이템정보를 DictDropContent타입의 배열인 self.rewardTableContents에 저장
    /// - Parameter completion: rewardTableContents를 사용하는 뷰의 reload 필요 시점
    func fetchRewardInfos() {
        var rewardInfos = [DictDropContent]()
        guard let rewards = selectedQuest.value?.reward else { return }
        for reward in rewards {
            self.sqliteManager.searchDetailData(dataName: reward.name) { (item: DictItem) in
                rewardInfos.append(DictDropContent(name: item.name, code: item.code, level: "", description: reward.description))
            }
        }
        let section = Section(index: 2, items: [.dropItem(rewardInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    func fetchQuestInfos() {
        guard let selectedQuest = selectedQuest.value else { return }
        let section = Section(index: 1, items: [.mainInfo(selectedQuest)])
        sectionData.updateSection(newSection: section)
        sectionData.updateSection(newSection: Section(index: 2, items: []))
    }
    
    func checkEmptyData() {
        if let value = selectedQuest.value {
            if value.defaultValues.isEmpty {
                emptyData.append(0)
            }
            if value.reward.isEmpty {
                emptyData.append(1)
            }
            if value.currentQuest == "" {
                emptyData.append(2)
            }
        }
    }
}
