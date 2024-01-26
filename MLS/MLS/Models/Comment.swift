//
//  Comment.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import Foundation

struct Comment: Codable {
    var id: UUID
    var date: Date
    var likeCount: [String]
    var comment: String
    var report:[String]
    var state: Bool
}
