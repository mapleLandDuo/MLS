//
//  CommunityPageViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import Foundation

class CommunityPageViewModel {
    // Properties
    private let dummy = [Post(id: UUID(), title: "1번 제목", date: Date(), upCount: 1), Post(id: UUID(), title: "2번 제목", date: Date(), upCount: 2), Post(id: UUID(), title: "3번 제목", date: Date(), upCount: 3), Post(id: UUID(), title: "4번 제목", date: Date(), upCount: 4)]

    // Methods
    func getPost() -> [Post] {
        return dummy
    }
}
