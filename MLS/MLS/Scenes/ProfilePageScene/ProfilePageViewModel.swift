//
//  ProfilePageViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/30/24.
//

import UIKit

class ProfilePageViewModel {
    
    // MARK: - Properties
    
    private let email: String
    
    let posts: Observable<[Post]> = Observable([])
    
    let nickName: String
    
    init(email: String, nickName: String) {
        self.email = email
        self.nickName = nickName
    }
}

// MARK: - Methods
extension ProfilePageViewModel {
    
    func loadPosts(completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.loadMyPosts(userEmail: email) { posts in
            self.posts.value = posts
            completion()
        }
    }

    func getPrivateEmail() -> String {
        guard var privateEmail = email.components(separatedBy: "@").first?.prefix(3) else { return "" }
        guard let id = email.components(separatedBy: "@").first else { return "" }
        while privateEmail.count != id.count { privateEmail += "*" }
        return String(privateEmail)
    }

    func getProfileEmail() -> String {
        return email
    }

    func isMyProfile() -> Bool {
        guard let myEmail = LoginManager.manager.email else { return false }
        return email == myEmail ? true : false
    }
}
