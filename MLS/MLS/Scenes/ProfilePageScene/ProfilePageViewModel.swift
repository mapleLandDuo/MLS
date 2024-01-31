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
    let nickName: Observable<String> = Observable("")
    init(id: String) {
        self.id = id
    }
    
}

extension ProfilePageViewModel {
    // MARK: - Method
    func loadPosts() {
        FirebaseManager.firebaseManager.loadMyPosts(userEmail: id) { posts in
            self.posts.value = posts
        }
    }
    
    func loadNickName() {
        FirebaseManager.firebaseManager.getNickname(userEmail: id) { str in
            self.nickName.value = str
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
