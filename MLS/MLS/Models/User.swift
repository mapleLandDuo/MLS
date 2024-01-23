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
    var state: UserState
    var blockedPost: [String]
    var blockedCommtent: [String]
    var blockedUser: [String]
}

enum UserState: Codable {
    case blockUser
    case normal
}




