//
//  DictionaryItem.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import Foundation

// MARK: - Dev 1.0.0
struct DictionaryItem: Codable {
    // 이름
    var name: String
    // id
    var code: String
    var level: String
    var str: String?
    var dex: String?
    var int: String?
    var luk: String?
    // 아이템 설명
    var description: String?
    // 분류
    var division: String
    // 주 카테고리
    var mainCategory: String
    // 부 카테고리
    var subCategory: String
    // 세부 정보
    var detailDescription: [String: String]
    // 드랍 테이블
    var dropTable: [DictionaryNameDescription]
}

// MARK: - Dev 1.0.1
protocol Sqlable: Codable {
    static var columnOrder: [String] { get }
    static var tableName: Filename { get }
}

struct DictItem: Sqlable {
    // 이름
    var name: String
    // id
    var code: String
    // 분류
    var division: String
    // 주 카테고리
    var mainCategory: String
    // 부 카테고리
    var subCategory: String
    // 기본 정보 [LEVEL,설명,STR,DEX,INT,LUK]
    var defaultValues: [DictionaryNameDescription]
    // 세부 정보 [물리공격력,마법공격력,공격속도,명중률,이동속도,성별,직업,마법방어력,물리방어력,STR,DEX,LUK,INT,최대마나,최대체력,회피율,상점 판매가]
    var detailValues: [DictionaryNameDescription]
    // 드랍 테이블
    var dropTable: [DictionaryNameDescription]
    
    static let columnOrder = ["name", "code", "division", "mainCategory", "subCategory", "defaultValues", "detailValues", "dropTable"]
    static let tableName = Filename.items
}
