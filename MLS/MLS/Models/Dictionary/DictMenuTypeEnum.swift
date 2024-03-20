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
