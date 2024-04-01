//
//  DictNPCViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/03.
//

import Foundation

import RxCocoa

class DictNPCViewModel: DictBaseViewModel {
    // MARK: Properties
    var tabMenus = ["출현 장소", "수락 퀘스트"]

    var selectedNPC = BehaviorRelay<DictNPC?>(value: nil)
    
    var tappedCellName = PublishRelay<String>()
    
    override init(selectedName: String) {
        super.init(selectedName: selectedName)
        fetchData(type: .npc, data: selectedNPC)
    }
}

// MARK: Methods
extension DictNPCViewModel {
    func fetchTagMaps() {
        guard let tagInfos = selectedNPC.value?.maps else { return }
        let section = Section(index: 1, items: [.tagInfo(tagInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    func fetchTagQuests() {
        guard let tagInfos = selectedNPC.value?.quests else { return }
        let section = Section(index: 1, items: [.tagInfo(tagInfos)])
        sectionData.updateSection(newSection: section)
    }
}
