//
//  User.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import Foundation

struct User: Codable {
    var id: String
    var nickName: String
    var state: State
    var blockingPosts: [String]
    var blockingComments: [String]
    var blockingUsers: [String]
    var blockedUsers: [String]
}
