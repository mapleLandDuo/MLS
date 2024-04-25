//
//  DictQuest.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/07.
//

import Foundation

// MARK: - Dev 1.0.0
//struct DictionaryQuest: Codable {
//    //이전 퀘스트
//    var preQuest: String?
//    //현재 퀘스트
//    var currentQuest: String
//    //다음 퀘스트
//    var laterQuest: String?
//    //반복 가능 횟수
//    var times: String
//    //시작 최소 레벨
//    var startMinLevel: String
//    //시작 최대 레벨
//    var startMaxLevel: String
//    //시작 필요 메소
//    var moneyToStart: String
//    //시작 npc
//    var startNPC: String
//    //종료 npc
//    var endNPC: String
//    //시작 가능 직업
//    var rollToStart: [String]
//    //완료 조건
//    var toCompletion: [DictionaryNameDescription?]
//    //보상
//    var reward: [DictionaryNameDescription?]
//}

// MARK: - Dev 1.0.1
struct DictQuest: DictEntity, Sqlable {
    var code: String
    var name: String
    //이전 퀘스트
    var preQuest: String?
    //현재 퀘스트
    var currentQuest: String
    //다음 퀘스트
    var laterQuest: String?
    //반복 가능 횟수
    var times: String
    //[시작 최소 레벨, 시작 최대 레벨, 시작 필요 메소, 시작 npc, 종료 npc]
    var defaultValues: [DictionaryNameDescription]
    //시작 가능 직업
    var rollToStart: [String]
    //완료 조건
    var toCompletion: [DictionaryNameDescription]
    //보상
    var reward: [DictionaryNameDescription]
    
    static let columnOrder = ["code", "name", "preQuest", "currentQuest", "laterQuest", "times", "defaultValues", "rollToStart", "toCompletion", "reward"]
    static let tableName = DictType.quest
}
