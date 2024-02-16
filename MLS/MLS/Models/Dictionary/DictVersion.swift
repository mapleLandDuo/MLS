//
//  DictVersion.swift
//  MLS
//
//  Created by SeoJunYoung on 2/16/24.
//

import Foundation

// MARK: - Version 1.0.1
struct DictVersion: Codable {
    var version: String
    
    var monsters: [DictMonster]
    
    var items: [DictItem]
    
    var maps: [DictMap]
    
    var npcs: [DictNPC]
    
    var quests: [DictQuest]
}
