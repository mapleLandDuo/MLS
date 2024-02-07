//
//  DictionaryMap.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/07.
//

import Foundation

struct DictionaryMap {
    var code: String
    var name: String
    var monsters: [DictionaryNameDescription?]
    var npcs: [DictionaryName?]
}

struct DictionaryName {
    var name: String
}
