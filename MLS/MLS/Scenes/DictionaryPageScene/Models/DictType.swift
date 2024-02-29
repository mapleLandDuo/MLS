//
//  DictType.swift
//  MLS
//
//  Created by SeoJunYoung on 2/28/24.
//

import UIKit

enum DictType: String {
    
    case item = "아이템"
    case monster = "몬스터"
    case npc = "NPC"
    case map = "맵"
    case quest = "퀘스트"
    
    var sortedArray: [DictSearchSortedEnum] {
        switch self {
        case .item:
            return [.defaultSorted, .highestLevel, .lowestLevel ]
        case .monster:
            return [ .defaultSorted, .highestLevel, .lowestLevel, .highestExp, .lowestExp]
        case .npc:
            return [.defaultSorted]
        case .map:
            return [.defaultSorted]
        case .quest:
            return [.defaultSorted]
        }
    }
    
    var sortedControllerSize: CGFloat {
        let cellCount:CGFloat = CGFloat(self.sortedArray.count)
        return (56 * cellCount) + (Constants.spacings.xl * 2) + 22
    }
    
    var filterArray: [DictSearchFilterEnum] {
        switch self {
        case .item:
            return [.job, .levelRange]
        case .monster:
            return [.levelRange]
        case .npc:
            return []
        case .map:
            return []
        case .quest:
            return []
        }
    }
    
    var filterControllerSize: CGFloat {
        let filterHeight:CGFloat = CGFloat(self.filterArray.map({$0.cellHeight}).reduce(0){$0 + $1})
        return filterHeight + 48 + Constants.spacings.xl + 34 + 22
    }
}
