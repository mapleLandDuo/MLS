//
//  DictEntity.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/04/25.
//

import Foundation

protocol DictEntity {
    var name: String { get }
    var code: String { get }

    static var columnOrder: [String] { get }
    static var tableName: DictType { get }
}
