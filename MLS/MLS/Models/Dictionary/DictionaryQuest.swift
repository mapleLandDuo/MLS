//
//  DictionaryQuest.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/07.
//

import Foundation

struct DictionaryQuest {
    var preQuest: String?
    var currentQuest: String
    var laterQuest: String?
    var times: String
    var startMinLevel: String
    var startMaxLevel: String
    var moneyToStart: String
    var startNPC: String
    var endNPC: String
    var rollToStart: [String]
    var toCompletion: [DictionaryNameDescription?]
    var reward: [DictionaryNameDescription?]
}
