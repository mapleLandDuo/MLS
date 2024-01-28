//
//  DictionaryItem.swift
//  MLS
//
//  Created by SeoJunYoung on 1/28/24.
//

import Foundation

struct DictionaryItemLink: Codable {
    var name: String
    var link: String
}

struct DictionaryItem: Codable {
    //이름
    var name: String
    //id
    var code: String
    var level: String
    var str: String?
    var dex: String?
    var int: String?
    var luk: String?
    //아이템 설명
    var discription: String?
    //분류
    var division: String
    //주 카테고리
    var mainCategory: String
    //부 카테고리
    var subCategory: String
    //세부 정보
    var detailDiscription: [String: String]
    //드랍 테이블
    var dropTable: [DictionaryItemDropTable]
}

struct DictionaryItemDropTable: Codable {
    var name: String
    var discription: String
}
