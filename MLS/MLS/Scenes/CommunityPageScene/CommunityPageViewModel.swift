//
//  CommunityPageViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import Foundation

class CommunityPageViewModel {
    // Properties
//    private let dummy = [Post(id: UUID(), title: "1번 제목", postImages: [], postContents: "1번 내용", user: "1번 유저", comment: [], date: Date(), likeCount: [], viewCount: 1, postType: .normal, report: [], state: true), Post(id: UUID(), title: "2번 제목", postImages: [], postContents: "2번 내용", user: "2번 유저", comment: [], date: Date(), likeCount: [], viewCount: 1, postType: .normal, report: [], state: true), Post(id: UUID(), title: "3번 제목", postImages: [], postContents: "3번 내용", user: "3번 유저", comment: [], date: Date(), likeCount: [], viewCount: 1, postType: .normal, report: [], state: true), Post(id: UUID(), title: "4번 제목", postImages: [], postContents: "4번 내용", user: "4번 유저", comment: [], date: Date(), likeCount: [], viewCount: 1, postType: .normal, report: [], state: true),]
    let loginManager = LoginManager()
    
    var posts: Observable<[Post]> = Observable(nil)
    var postsCount = 0
    
    let type: BoardSeparatorType
    
    init(type: BoardSeparatorType) {
        self.type = type
    }
}

extension CommunityPageViewModel {
    // Methods
    func getPost(completion: @escaping ([Post]) -> Void){
        switch type {
        case .normal:
            FirebaseManager.firebaseManager.loadPosts(type: [.normal]) { [weak self] post in
                if let post = post {
                    self?.postsCount = post.count
                    completion(post)
                }
            }
        case .buy, .sell, .complete:
            FirebaseManager.firebaseManager.loadPosts(type: [.buy, .sell, .complete]) { [weak self] post in
                if let post = post {
                    self?.postsCount = post.count
                    completion(post)
                }
            }
        }
    }
    
    func isLogin() -> Bool {
        return loginManager.isLogin()
    }
}
