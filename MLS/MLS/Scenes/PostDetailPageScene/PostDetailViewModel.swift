//
//  PostDetailViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import Foundation

class PostDetailViewModel {
    // MARK: Properties

    var loginManager = LoginManager()
    
    var comments: Observable<[Comment]> = Observable(nil)
//    var commentCount: Observable<Int> = Observable(0)
    lazy var commentCount = 0
    var post: Observable<Post> = Observable(nil)
    
    var isEditing = false
    var editingComment: Comment?
    
    init(post: Post) {
        self.post.value = post
    }
    
    // MARK: Method

    func deletPost(postId: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.deletePost(postID: postId) {
            completion()
        }
    }
    
    func loadComment(postId: String) {
        FirebaseManager.firebaseManager.loadComments(postID: postId) { comments in
            if let count = comments?.count {
                self.commentCount = count
            }
            self.comments.value = comments
        }
    }
    
    func saveComment(postId: String, comment: Comment, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.saveComment(postID: postId, comment: comment) {
            completion()
        }
    }
    
    func updateComment(postId: String, comment: Comment, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.updateComment(postID: postId, comment: comment) {
            completion()
        }
    }
    
    func deleteComment(postId: String, commentId: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.deleteComment(postID: postId, commentID: commentId) {
            completion()
        }
    }
    
    func reportPost(postID: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.reportPost(postID: postID) {
            completion()
        }
    }
    
    func reportComment(postID: String, commentID: String, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.reportComment(postId: postID, commentId: commentID) {
            completion()
        }
    }
    
    func checkMyPost() -> Bool {
        return post.value?.user == Utils.currentUser
    }
    
    func isLogin() -> Bool {
        return loginManager.isLogin()
    }
}
