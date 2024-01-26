//
//  PostDetailViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/26.
//

import Foundation

class PostDetailViewModel {
    //MARK: Properties
    var comments: Observable<[Comment]> = Observable(nil)
    var post: Observable<Post> = Observable(nil)
    
    //MARK: Method
    func loadComment(postId: String) {
        FirebaseManager.firebaseManager.loadComments(postID: postId) { comments in
            self.comments.value = comments
        }
    }
    
    func savePost(postId: String, comment: Comment) {
        FirebaseManager.firebaseManager.saveComment(postID: postId, comment: comment)
    }
}
