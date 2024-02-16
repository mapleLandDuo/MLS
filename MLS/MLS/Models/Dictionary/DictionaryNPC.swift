//
//  DictionaryNPC.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/07.
//

import Foundation

// MARK: - Dev 1.0.0
struct DictionaryNPC: Codable {
    var code: String
    var name: String
    var quests: [DictionaryNameDescription?]
}

// MARK: - Dev 1.0.1
struct DictNPC: Codable {
    var code: String
    var name: String
    var maps: [String]
    var quests: [String]
}
