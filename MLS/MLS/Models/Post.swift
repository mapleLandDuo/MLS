//
//  Post.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import Foundation

struct Post: Codable {
    var id: UUID
    var title: String
    var postImages: [URL?]
    var postContent: String
    var user: String
    var date: Date
    var likeCounts: [String]
    var viewCount: Int
    var postType: BoardSeparatorType
    var reports: [String]
    var state: State
}
