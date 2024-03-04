//
//  DictMapViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/02.
//

import Foundation

class DictMapViewModel {
    // MARK: Properties
    let sqliteManager = SqliteManager()
    
    var selectedTab: Observable<Int> = Observable(0)
    var tabMenus = ["출현 몬스터","NPC"]
    
    var selectedName: String?
    
    var selectedMap: Observable<DictMap> = Observable(nil)
    
    var apearMonsterContents = [DictDropContent]()
    
    var apearNpcContents = [DictDropContent]()
    
    init(selectedName: String) {
        self.selectedName = selectedName
    }
}

// MARK: Methods
extension DictMapViewModel {
    func fetchMenuIndex() -> Int {
        guard let index = selectedTab.value else { return 0 }
        return index
    }
    
    func setMenuIndex(index: Int) {
        selectedTab.value = index
    }
    
    func fetchMap() {
        guard let name = self.selectedName else { return }
        sqliteManager.searchDetailData(dataName: name) { [weak self] (item: DictMap) in
            self?.selectedMap.value = item
        }
    }
    
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
