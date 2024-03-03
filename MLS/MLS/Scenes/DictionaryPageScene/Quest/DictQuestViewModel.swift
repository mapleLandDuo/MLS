//
//  DictQuestViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import Foundation

class DictQuestViewModel {
    // MARK: Properties
    let sqliteManager = SqliteManager()
    
    var selectedTab: Observable<Int> = Observable(0)
    var tabMenus = ["정보 & 완료조건","퀘스트 보상","퀘스트 순서"]
    
    var selectedName: String?
    
    var selectedQuest: Observable<DictQuest> = Observable(nil)
    
    var completeTableContents = [DictDropContent]()
    
    var rewardTableContents = [DictDropContent]()
    
    init(selectedName: String) {
        self.selectedName = selectedName
    }
}

// MARK: Methods
extension DictQuestViewModel {
    func fetchMenuIndex() -> Int {
        guard let index = selectedTab.value else { return 0 }
        return index
    }
    
    func setMenuIndex(index: Int) {
        selectedTab.value = index
    }
    
    func fetchQuest() {
        guard let name = self.selectedName else { return }
        sqliteManager.searchDetailData(dataName: name) { [weak self] (item: DictQuest) in
            self?.selectedQuest.value = item
        }
    }
    
    func fetchDefaultInfos() -> [DetailContent]? {
        guard let times = selectedQuest.value?.times else { return [] }
        var result = [DetailContent]()
        result.append(DetailContent(title: "반복", description: times))
        result += selectedQuest.value?.defaultValues.map { DetailContent(title: $0.name, description: $0.description) } ?? []
        return result
    }
    
    func fetchCompleteInfos(completion: @escaping () -> Void) {
        guard let completions = selectedQuest.value?.toCompletion else { return }
        for completion in completions {
            if completion.description.contains("전달") {
                self.sqliteManager.searchDetailData(dataName: completion.name) { [weak self] (item: DictItem) in
                    self?.completeTableContents.append(DictDropContent(name: item.name, code: item.code, level: "", description: completion.description))
                }
            } else {
                self.sqliteManager.searchDetailData(dataName: completion.name) { [weak self] (item: DictMonster) in
                    self?.completeTableContents.append(DictDropContent(name: item.name, code: item.code, level: "", description: completion.description))
                }
            }
        }
        completion()
    }
    
    func fetchRewardTableContents() -> [DetailContent] {
        var result = [DetailContent]()
        selectedQuest.value.map {
            if let meso = $0.reward.first(where: { $0.name == "메소" })?.description {
                result.append(DetailContent(title: "메소", description: meso))
            }
        }
        selectedQuest.value.map {
            if let exp = $0.reward.first(where: { $0.name == "경험치" })?.description {
                result.append(DetailContent(title: "경험치", description: exp))
            }
        }
        selectedQuest.value.map {
            if let popularity = $0.reward.first(where: { $0.name == "인기도" })?.description {
                result.append(DetailContent(title: "인기도", description: popularity))
            }
        }
        return result
    }
    
    func fetchRewardInfos(completion: @escaping () -> Void) {
        guard let rewards = selectedQuest.value?.reward else { return }
        for reward in rewards {
            self.sqliteManager.searchDetailData(dataName: reward.name) { [weak self] (item: DictItem) in
                self?.rewardTableContents.append(DictDropContent(name: item.name, code: item.code, level: "", description: reward.description))
            }
        }
        completion()
    }
}
