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
    var tabMenus = ["출현 몬스터","NPC"]
    
    var selectedMap = BehaviorRelay<DictMap?>(value: nil)
    
    var tappedCellName = PublishRelay<String>()
    
    override init(selectedName: String) {
        super.init(selectedName: selectedName)
        fetchData(type: .map, data: selectedMap)
    }
}

// MARK: Methods
extension DictMapViewModel {
    func fetchApearMonsters() {
        var apearMonsterInfos = [DictDropContent]()
        guard let monsters = selectedMap.value?.monsters else { return }
        for monster in monsters {
            self.sqliteManager.searchDetailData(dataName: monster.name) { (item: DictMonster) in
                guard let level = item.defaultValues.filter({ $0.name == "LEVEL" }).first?.description else { return}
                apearMonsterInfos.append(DictDropContent(name: item.name, code: item.code, level: level, description: monster.description))
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
                apearNPCInfo.append(DictDropContent(name: item.name, code: item.code, level: "", description: ""))
            }
        }
        let section = Section(index: 1, items: [.dropItem(apearNPCInfo)])
        sectionData.updateSection(newSection: section)
    }
}
