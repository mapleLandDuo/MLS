//
//  FirebaseManager.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/21.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class FirebaseManager {
    static let firebaseManager = FirebaseManager()

    let db = Firestore.firestore()

}

extension FirebaseManager {
    // MARK: Post
    func savePost(post: Post) {
        do {
            let data = try Firestore.Encoder().encode(post)
            db.collection("posts").document(post.id.uuidString).setData(data)
        } catch {
            print(error)
        }
    }

    func loadPosts(type: BoardSeparatorType, completion: @escaping ([Post]?) -> Void) {
        db.collection("posts").whereField("postType", isEqualTo: type.toString).order(by: "date", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [Post] = []
                for document in querySnapshot?.documents ?? [] {
                    do {
                        let post = try Firestore.Decoder().decode(Post.self, from: document.data())
                        posts.append(post)
                    } catch {
                        completion(nil)
                        return
                    }
                }
                completion(posts)
            }
        }
    }

    func saveImages(images: [UIImage?], completion: @escaping ([URL?]) -> Void) {
        var tempList = [URL?]()
        let group = DispatchGroup()

        images.forEach { image in
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.3) else { return }
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"

            let imageName = "\(UUID().uuidString) + \(String(Date().toString()))"
            let firebaseReference = Storage.storage().reference().child("PostImages").child("\(imageName)")

            group.enter()

            firebaseReference.putData(imageData, metadata: metaData) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                    group.leave()
                } else {
                    print("성공")
                    firebaseReference.downloadURL { url, _ in
                        tempList.append(url)
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .main) {
            completion(tempList)
        }
    }
}

extension FirebaseManager {
    // MARK: Comment
    func saveComment(postID: String, comment: Comment) {
        do {
            let data = try Firestore.Encoder().encode(comment)
            db.collection("posts").document(postID).collection("comments").document(comment.id.uuidString).setData(data)
        } catch {
            print(error)
        }
    }
    
    func loadComments(postID: String, completion: @escaping ([Comment]?) -> Void) {
        db.collection("posts").document(postID).collection("comments").order(by: "date", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var comments: [Comment] = []
                for document in querySnapshot?.documents ?? [] {
                    do {
                        let comment = try Firestore.Decoder().decode(Comment.self, from: document.data())
                        comments.append(comment)
                    } catch {
                        completion(nil)
                        return
                    }
                }
                completion(comments)
            }
        }
    }

}
