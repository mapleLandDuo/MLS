//
//  Post.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import Foundation
import UIKit

struct Post: Codable {
    var id: UUID
    var title: String
    var postImages: [URL?]
    var postContents: String
    var user: String
    var comment: [UUID]
    var date: Date
    var likeCount: [String]
    var viewCount: Int
    var postType: BoardSeparatorType
    var report: [String]
    var state: Bool
}
