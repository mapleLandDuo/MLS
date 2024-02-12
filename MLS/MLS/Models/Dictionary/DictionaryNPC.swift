//
//  DictionaryNPC.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/07.
//

import Foundation

struct DictionaryNPC: Codable {
    var code: String
    var name: String
    var quests: [DictionaryNameDescription?]
}
