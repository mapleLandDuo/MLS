//
//  CommunityPageViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import Foundation

class CommunityPageViewModel {
    // Properties
    private let dummy = [Post(title: "1번 제목", date: Date(), upCount: 1), Post(title: "2번 제목", date: Date(), upCount: 2), Post(title: "3번 제목", date: Date(), upCount: 3), Post(title: "4번 제목", date: Date(), upCount: 4)]

    // Methods
    func getPost() -> [Post] {
        return dummy
    }
}
