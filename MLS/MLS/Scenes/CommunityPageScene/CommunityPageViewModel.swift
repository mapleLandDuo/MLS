//
//  CommunityPageViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import Foundation

enum SortType {
    case new
    case popular
}

class CommunityPageViewModel {
    // MARK: - Properties

    var posts: Observable<[Post]> = Observable(nil)

    var postsCount = 0

    let type: BoardSeparatorType

    let sortType: Observable<SortType> = Observable(.new)

    init(type: BoardSeparatorType) {
        self.type = type
    }
}

// MARK: - Methods
extension CommunityPageViewModel {
    func fetchPosts(sort: SortType, completion: @escaping ([Post]?) -> Void) {
        switch (type, sort) {
        case (.normal, .new):
            fetchPopularPosts(type: [.normal]) { post in
                completion(post)
            }

        case (.normal, .popular):
            fetchPopularPosts(type: [.normal]) { post in
                completion(post)
            }
        case (.buy, .new), (.sell, .new), (.complete, .new):
            fetchPopularPosts(type: [.buy, .sell, .complete]) { post in
                completion(post)
            }

        case (.buy, .popular), (.sell, .popular), (.complete, .popular):
            fetchPopularPosts(type: [.buy, .sell, .complete]) { post in
                completion(post)
            }
        }
    }

    func fetchPopularPosts(type: [BoardSeparatorType], completion: @escaping ([Post]?) -> Void) {
        FirebaseManager.firebaseManager.fetchPopularPosts(type: type) { [weak self] post in
            if let post = post {
                self?.postsCount = post.count
                completion(post)
            } else {
                completion(nil)
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
        return LoginManager.manager.isLogin()
    }
}
