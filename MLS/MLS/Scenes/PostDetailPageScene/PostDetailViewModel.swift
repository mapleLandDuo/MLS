//
//  PostDetailViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import Foundation

class PostDetailViewModel {
    //MARK: Properties
    var loginManager = LoginManager()
    
    var comments: Observable<[Comment]> = Observable(nil)
//    var commentCount: Observable<Int> = Observable(0)
    lazy var commentCount = 0
    var post: Observable<Post> = Observable(nil)
    
    init(post: Post) {
        self.post.value = post
    }
    
    //MARK: Method
    func loadComment(postId: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.loadComments(postID: postId) { comments in
            self.comments.value = comments
            if let count = comments?.count {
                self.commentCount = count
            }
            completion()
        }
    }
    
    func saveComment(postId: String, comment: Comment, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.saveComment(postID: postId, comment: comment)
        completion()
    }
    
    func isLogin() -> Bool {
        return loginManager.isLogin()
    }
}
