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
    let sortType: Observable<SortType> = Observable(.new)
    
    init(type: BoardSeparatorType) {
        self.type = type
    }
}

extension CommunityPageViewModel {
    // Methods
    func loadPosts(sort: SortType, completion: @escaping ([Post]?) -> Void) {
        switch (type, sort) {
        case (.normal, .new):
            FirebaseManager.firebaseManager.newPosts(type: [.normal]) { [weak self] post in
                if let post = post {
                    self?.postsCount = post.count
                    completion(post)
                } else {
                    completion(nil)
                }
            }
            
        case (.normal, .popular):
            FirebaseManager.firebaseManager.popularPosts(type: [.normal]) { [weak self] post in
                if let post = post {
                    self?.postsCount = post.count
                    completion(post)
                } else {
                    completion(nil)
                }
            }
        case (.buy, .new), (.sell, .new), (.complete, .new):
            FirebaseManager.firebaseManager.newPosts(type: [.buy, .sell, .complete]) { [weak self] post in
                if let post = post {
                    self?.postsCount = post.count
                    completion(post)
                } else {
                    completion(nil)
                }
            }
            
        case (.buy, .popular), (.sell, .popular), (.complete, .popular):
            FirebaseManager.firebaseManager.popularPosts(type: [.buy, .sell, .complete]) { [weak self] post in
                if let post = post {
                    self?.postsCount = post.count
                    completion(post)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func searchPosts(text: String, completion: @escaping () -> Void) {
        if text == "" {
            guard let sortType = sortType.value else { return }
            loadPosts(sort: sortType) { [weak self] posts in
                guard let posts = posts else { return }
                self?.posts.value = posts
            }
        } else {
            FirebaseManager.firebaseManager.searchPosts(text: text) { [weak self] posts in
                guard let posts = posts else { return }
                self?.postsCount = posts.count
                self?.posts.value = posts
                completion()
            }
        }
    }
    
    func isLogin() -> Bool {
        return loginManager.isLogin()
    }
}

enum SortType {
    case new
    case popular
}
