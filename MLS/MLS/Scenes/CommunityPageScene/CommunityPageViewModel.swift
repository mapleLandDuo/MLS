//
//  CommunityPageViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import Foundation

class CommunityPageViewModel {
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
    
    func searchPosts(text: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.firebaseManager.searchPosts(text: text) { [weak self] posts in
            guard let posts = posts else { return }
            if posts.isEmpty {
                completion(false)
            } else {
                self?.postsCount = posts.count
                self?.posts.value = posts
                completion(true)
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
