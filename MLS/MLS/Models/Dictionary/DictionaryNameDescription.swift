//
//  DictionaryNameDescription.swift
//  MLS
//
//  Created by SeoJunYoung on 2/5/24.
//

import Foundation

struct DictionaryNameDescription: DictCellProtocol, Codable {
    var title: String
    var description: String

    enum CodingKeys: String, CodingKey {
        case title = "name"
        case description
    }
}
