//
//  DictMenuTypeEnum.swift
//  MLS
//
//  Created by SeoJunYoung on 3/20/24.
//

import Foundation

enum DictMenuTypeEnum: String {
    case total = "전체"
    case monster = "몬스터"
    case item = "아이템"
    case map = "맵"
    case npc = "NPC"
    case quest = "퀘스트"
    
    func convertToInt() -> Int {
        switch self {
        case .total:
            return 0
        case .monster:
            return 1
        case .item:
            return 2
        case .map:
            return 3
        case .npc:
            return 4
        case .quest:
            return 5
        }
    }
    
    func convertToDictType() -> DictType {
        switch self {
        case .total:
            return .item
        case .monster:
            return .monster
        case .item:
            return .item
        case .map:
            return .map
        case .npc:
            return .npc
        case .quest:
            return .quest
        }
    }
}

struct DictMenuItem {
    var type: DictMenuTypeEnum
    var count: Int
    
    var getMenuString: String {
        get {
            return self.type.rawValue + "(\(self.count))"
        }
    }
}
