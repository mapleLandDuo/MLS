//
//  CommunityPageViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import Foundation

class CommunityPageViewModel {
    // Properties
    private let dummy = [Post(id: UUID(), title: "1번 제목", postImages: [], postContents: "1번 내용", user: "1번 유저", comment: [], date: Date(), likeCount: [], viewCount: 1, postType: .normal, report: [], state: true), Post(id: UUID(), title: "2번 제목", postImages: [], postContents: "2번 내용", user: "2번 유저", comment: [], date: Date(), likeCount: [], viewCount: 1, postType: .normal, report: [], state: true), Post(id: UUID(), title: "3번 제목", postImages: [], postContents: "3번 내용", user: "3번 유저", comment: [], date: Date(), likeCount: [], viewCount: 1, postType: .normal, report: [], state: true), Post(id: UUID(), title: "4번 제목", postImages: [], postContents: "4번 내용", user: "4번 유저", comment: [], date: Date(), likeCount: [], viewCount: 1, postType: .normal, report: [], state: true),]

    // Methods
    func getPost() -> [Post] {
        return dummy
    }
}
