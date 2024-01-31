//
//  Comment.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import Foundation

struct Comment: Codable {
    var id: UUID
    var user: String
    var date: Date
    var likeCounts: [String]
    var comment: String
    var reports:[String]
    var state: State
}
