//
//  DictionaryMap.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/07.
//

import Foundation

struct DictionaryMap: Codable {
    var code: String
    var name: String
    var monsters: [DictionaryNameDescription?]
    var npcs: [String?]
}
