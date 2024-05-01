//
//  DictMapViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import Foundation

import RxCocoa

class DictMapViewModel: DictBaseViewModel {
    // MARK: Properties
    var selectedMap = BehaviorRelay<DictMap?>(value: nil)
    
    var tappedCellName = PublishRelay<String>()
    var tappedExpandButton = PublishRelay<Bool>()
    
    override init(selectedName: String, type: DictType) {
        super.init(selectedName: selectedName, type: type)
        fetchData(type: type, data: selectedMap)
        checkEmptyData()
    }
}

// MARK: Methods
extension DictMapViewModel {
    func fetchApearMonsters() {
        var apearMonsterInfos = [DictDropContent]()
        guard let monsters = selectedMap.value?.monsters else { return }
        for monster in monsters {
            self.sqliteManager.searchDetailData(dataName: monster.title) { (item: DictMonster) in
                guard let level = item.defaultValues.filter({ $0.title == "LEVEL" }).first?.description else { return}
                apearMonsterInfos.append(DictDropContent(title: item.name, code: item.code, level: level, description: monster.description))
            }
        }
        let section = Section(index: 1, items: [.dropItem(apearMonsterInfos)])
        sectionData.updateSection(newSection: section)
    }
    
    func fetchApearNPCs() {
        var apearNPCInfo = [DictDropContent]()
        guard let npcs = selectedMap.value?.npcs else { return }
        for npc in npcs {
            self.sqliteManager.searchDetailData(dataName: npc) { (item: DictNPC) in
                apearNPCInfo.append(DictDropContent(title: item.name, code: item.code, level: "", description: ""))
            }
        }
        let section = Section(index: 1, items: [.dropItem(apearNPCInfo)])
        sectionData.updateSection(newSection: section)
    }
    
    func checkEmptyData() {
        if let value = selectedMap.value {
            if value.monsters.isEmpty {
                emptyData.append(0)
            }
            if value.npcs.isEmpty {
                emptyData.append(1)
            }
        }
    }
}
