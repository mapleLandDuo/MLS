//
//  AddPostViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

class AddPostViewModel {
    // MARK: Properties

    let loginManager = LoginManager()

    var imageData: Observable<[UIImage?]> = Observable([])
    var postData: Observable<Post> = Observable(nil)
    let type: BoardSeparatorType

    init(type: BoardSeparatorType) {
        self.type = type
    }
}

extension AddPostViewModel {
    // MARK: Method

    func savePost(post: Post, images: [UIImage?]) {
        var post = post
        FirebaseManager.firebaseManager.saveImages(images: images) { [weak self] urls in
            self?.postData.value?.postImages = urls
            post.postImages = urls
            FirebaseManager.firebaseManager.savePost(post: post)
        }
    }

    func getUser() -> String {
        return loginManager.email ?? ""
    }
}
