//
//  DictMonster.swift
//  MLS
//
//  Created by SeoJunYoung on 1/27/24.
//

import Foundation

// MARK: - Dev 1.0.0
//struct DictionaryMonster: Codable {
//    // ID
//    let code: String
//    // 이름
//    let name: String
//    // 레벨
//    let level: Int
//    // 경험치
//    let exp: Int
//    // 체력
//    let hp: Int
//    // 마나
//    let mp: Int
//    // 출몰지역
//    let hauntArea: [String]
//    // 물리 방어력
//    let physicalDefense: Int
//    // 마법 방어력
//    let magicDefense: Int
//    // 필요 명중률
//    let requiredAccuracy: Int
//    // 레벨별 명중률
//    let levelAccuracy: String
//    // 회피율
//    let evasionRate: Int
//    // 드랍 테이블
//    let dropTable: [DictionaryNameDescription]
//}

// MARK: - Dev 1.0.1
struct DictMonster: DictEntity {
    // ID
    var code: String
    // 이름
    var name: String
    // 기본 정보 [레벨,경험치,HP,MP]
    var defaultValues: [DictionaryNameDescription]
    // 세부 정보 [특성,물리방어력,마법방어력,필요명중률,회피율]
    var detailValues: [DictionaryNameDescription]
    // 출몰 지역
    var hauntArea: [String]
    // 드랍 테이블
    var dropTable: [DictionaryNameDescription]
    
    static let columnOrder = ["code", "name", "defaultValues", "detailValues", "hauntArea", "dropTable"]
    static let tableName = DictType.monster
}
