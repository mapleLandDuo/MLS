//
//  Sqlable.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/04/25.
//

import Foundation

protocol Sqlable: Codable {
    static var columnOrder: [String] { get }
    static var tableName: DictType { get }
}
