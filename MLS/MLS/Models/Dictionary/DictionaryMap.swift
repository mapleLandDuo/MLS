//
//  DictionaryMap.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/07.
//

import Foundation

// MARK: - Dev 1.0.0
struct DictionaryMap: Codable {
    var code: String
    var name: String
    var monsters: [DictionaryNameDescription?] // 이름 , 갯수
    var npcs: [String?]
}

// MARK: - Dev 1.0.1
struct DictMap: Codable {
    var code: String
    var name: String
    var monsters: [DictionaryNameDescription] // 이름 , 갯수
    var npcs: [String]
    
    static let columnOrder = ["code TEXT", "name TEXT", "monsters TEXT", "npcs TEXT"]
}
