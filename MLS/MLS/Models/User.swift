//
//  User.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import Foundation

struct User {
    var id: String
    var nickName: String
    var state: UserState
    var blockedPost: [String]
    var blockedCommtent: [String]
    var blockedUser: [String]
}

enum UserState {
    case blockUser
    case normal
}




