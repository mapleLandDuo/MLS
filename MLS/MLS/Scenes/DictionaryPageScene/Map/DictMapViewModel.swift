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
    
//    var selectedMap: TempObservable<DictMap> = TempObservable(nil)
    var selectedMap = BehaviorRelay<DictMap?>(value: nil)
    
    var apearMonsterContents = [DictDropContent]()
    
    var apearNpcContents = [DictDropContent]()
}

// MARK: Methods
extension DictMapViewModel {
    func fetchApearMonsters(completion: @escaping () -> Void) {
        guard let monsters = selectedMap.value?.monsters else { return }
        for monster in monsters {
            self.sqliteManager.searchDetailData(dataName: monster.name) { [weak self] (item: DictMonster) in
                guard let level = item.defaultValues.filter({ $0.name == "LEVEL" }).first?.description else { return}
                self?.apearMonsterContents.append(DictDropContent(name: item.name, code: item.code, level: level, description: monster.description))
            }
        }
        completion()
    }
    
    func fetchApearNPCs(completion: @escaping () -> Void) {
        guard let npcs = selectedMap.value?.npcs else { return }
        for npc in npcs {
            self.sqliteManager.searchDetailData(dataName: npc) { [weak self] (item: DictNPC) in
                self?.apearNpcContents.append(DictDropContent(name: item.name, code: item.code, level: "", description: ""))
            }
        }
        completion()
    }
}
