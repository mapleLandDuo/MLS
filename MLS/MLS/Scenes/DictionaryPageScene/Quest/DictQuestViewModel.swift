//
//  DictQuestViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import Foundation

class DictQuestViewModel: DictBaseViewModel {
    // MARK: Properties
    var tabMenus = ["정보 & 완료조건","퀘스트 보상","퀘스트 순서"]
    
    var selectedQuest: Observable<DictQuest> = Observable(nil)
    
    var completeTableContents = [DictDropContent]()
    
    var rewardTableContents = [DictDropContent]()
}

// MARK: Methods
extension DictQuestViewModel {
    /// 퀘스트의 반복회수와 defaultValues 속성을 DetailContent 타입의 배열로 변경
    /// - Returns: 뷰에 뿌려질 DetailConetent 타입의 배열
    func fetchDefaultInfos() -> [DetailContent]? {
        guard let times = selectedQuest.value?.times else { return [] }
        var result = [DetailContent]()
        result.append(DetailContent(title: "반복", description: times))
        result += selectedQuest.value?.defaultValues.map { DetailContent(title: $0.name, description: $0.description) } ?? []
        return result
    }
    
    /// 퀘스트의 완료조건을 DictDropContent타입의 배열인 self.completeTableContents에 저장
    /// - Parameter completion: completeTableContents를 사용하는 뷰 reload 필요 시점
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
    
    /// 퀘스트 보상정보의 텍스트정보를 DetailContent타입의 배열로 변경
    /// - Returns: 변경된 DetailConetnt 배열
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
    
    /// 퀘스트 보상정보의 아이템정보를 DictDropContent타입의 배열인 self.rewardTableContents에 저장
    /// - Parameter completion: rewardTableContents를 사용하는 뷰의 reload 필요 시점
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
