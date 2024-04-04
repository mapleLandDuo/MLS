//
//  Int+.swift
//  MLS
//
//  Created by SeoJunYoung on 3/26/24.
//

import Foundation

extension Int {
    func convertDictMenuTypeEnum() -> DictMenuTypeEnum {
        let type: DictMenuTypeEnum = { switch self {
        case 0:
            return .total
        case 1:
            return .monster
        case 2:
            return .item
        case 3:
            return .map
        case 4:
            return .npc
        case 5:
            return .quest
        default:
            return .total
        }
        }()
        return type
    }
}
