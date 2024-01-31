//
//  ProfilePageViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/30/24.
//

import Foundation
import UIKit

class ProfilePageViewModel {
    private let id: String
    let posts: Observable<[Post]> = Observable([])
    let nickName: String
    init(id: String, nickName: String) {
        self.id = id
        self.nickName = nickName
    }
    
}

extension ProfilePageViewModel {
    // MARK: - Method
    func loadPosts(completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.loadMyPosts(userEmail: id) { posts in
            self.posts.value = posts
            completion()
        }
    }
    
    
    func getEmail() -> String {
        guard var email = id.components(separatedBy: "@").first?.prefix(3) else { return "" }
        guard var id = id.components(separatedBy: "@").first else { return "" }
        while email.count != id.count {
            email += "*"
        }
        return String(email)
    }
}
