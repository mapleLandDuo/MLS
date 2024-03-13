//
//  URL+.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/12.
//

import Foundation

extension URL {
    static func getImageUrl(code: String, type: DictType) -> URL? {
        switch type {
        case .item:
            return URL(string: "https://maplestory.io/api/gms/62/item/\(code)/icon?resize=2")
        case .monster:
            return URL(string: "https://maplestory.io/api/gms/62/mob/\(code)/render/move?bgColor=")
        case .map:
            return URL(string: "https://mapledb.kr/Assets/image/minimaps/\(code).png")
        case .npc:
            return URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon?resize=2")
        case .quest:
            return URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon")
        }
    }
}
