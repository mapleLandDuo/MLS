//
//  DictionaryMonster.swift
//  MLS
//
//  Created by SeoJunYoung on 1/27/24.
//

import Foundation

struct DictionaryMonster: Codable {
    // ID
    let code: String
    //이름
    let name: String
    //레벨
    let level: Int
    //경험치
    let exp: Int
    //체력
    let hp: Int
    //마나
    let mp: Int
    //출몰지역
    let hauntArea: [String]
    //물리 방어력
    let physicalDefense: Int
    //마법 방어력
    let magicDefense: Int
    //필요 명중률
    let requiredAccuracy: Int
    //레벨별 명중률
    let levelAccuracy: String
    //회피율
    let evasionRate: Int
    //드랍 테이블
    let dropTable: [DictionaryMonsterDropTable]
}

struct DictionaryMonsterDropTable: Codable {
    let name: String
    let discription: String
}
