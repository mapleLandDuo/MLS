//
//  URL+.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/12.
//

import Foundation

extension URL {
    static func getImageUrl(code: String, type: Filename) -> URL? {
        switch type {
        case .items:
            return URL(string: "https://maplestory.io/api/gms/62/item/\(code)/icon?resize=2")
        case .monsters:
            return URL(string: "https://maplestory.io/api/gms/62/mob/\(code)/render/move?bgColor=")
        case .maps:
            return URL(string: "https://mapledb.kr/Assets/image/minimaps/\(code).png")
        case .npcs:
            return URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon?resize=2")
        case .quests:
            return URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon")
        }
    }
}
