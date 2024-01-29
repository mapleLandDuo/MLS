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

    // 게시글 전부 가져오기
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

    // 게시글 id로 가져오기
    func loadPost(id: String, completion: @escaping (Post?) -> Void) {
        db.collection("posts").document(id).getDocument { documentSnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists, let data = documentSnapshot.data() {
                do {
                    let post = try Firestore.Decoder().decode(Post.self, from: data)
                    completion(post)
                } catch {
                    print("데이터를 디코딩하지 못했습니다: \(error)")
                    completion(nil)
                }
            } else {
                print("문서가 존재하지 않습니다.")
                completion(nil)
            }
        }
    }

    func updatePost(post: Post) {
        do {
            let data = try Firestore.Encoder().encode(post)
            db.collection("posts").document(post.id.uuidString).updateData(data)
        } catch {
            print(error)
        }
    }

    func deletePost(postID: String) {
        db.collection("posts").document(postID).delete { error in
            if let error = error {
                print("게시글 삭제 실패: \(error)")
            } else {
                print("게시글 삭제 성공")
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

    // 게시글 댓글 가져오기
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

    // 유저 댓글 가져오기
    func loadComments(userID: String, completion: @escaping ([Comment]?) -> Void) {
        db.collection("posts").getDocuments { postQuerySnapshot, postError in
            if let postError = postError {
                print("게시물을 가져오지 못했습니다: \(postError)")
                completion(nil)
                return
            }

            var comments: [Comment] = []
            let dispatchGroup = DispatchGroup()

            for postDocument in postQuerySnapshot?.documents ?? [] {
                let postID = postDocument.documentID
                dispatchGroup.enter()

                let commentsQuery = self.db.collection("posts").document(postID).collection("comments").whereField("user", isEqualTo: userID).order(by: "date", descending: true)

                commentsQuery.getDocuments { commentsQuerySnapshot, commentsError in
                    if let commentsError = commentsError {
                        print("댓글을 가져오지 못했습니다: \(commentsError)")
                        dispatchGroup.leave()
                        return
                    }

                    for commentDocument in commentsQuerySnapshot?.documents ?? [] {
                        do {
                            let comment = try Firestore.Decoder().decode(Comment.self, from: commentDocument.data())
                            comments.append(comment)
                        } catch {
                            print("댓글을 디코드하는데 실패했습니다.")
                            dispatchGroup.leave()
                            return
                        }
                    }

                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(comments)
            }
        }
    }

    func updateComment(postID: String, comment: Comment) {
        do {
            let data = try Firestore.Encoder().encode(comment)
            db.collection("posts").document(postID).collection("comments").document(comment.id.uuidString).updateData(data)
        } catch {
            print(error)
        }
    }

    func deleteComment(postID: String, commentID: String) {
        db.collection("posts").document(postID).collection("comments").document(commentID).delete { error in
            if let error = error {
                print("댓글 삭제 실패: \(error)")
            } else {
                print("댓글 삭제 성공")
            }
        }
    }
}

extension FirebaseManager  {
    func updateDictionaryItemLink(item: DictionaryNameLinkUpdateItem, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(item)
            db.collection("dictionaryItemLink").document(item.name).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    func updateDictionaryMonsterLink(item: DictionaryNameLinkUpdateItem, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(item)
            db.collection("dictionaryMonsterLink").document(item.name).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func saveDictionaryMonster(item: DictionaryMonster, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(item)
            db.collection("dictionaryMonsters").document(item.name).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    func saveDictionaryItem(item: DictionaryItem, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(item)
            db.collection("dictionaryItems").document(item.name).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func loadItemLinks(completion: @escaping ([DictionaryNameLinkUpdateItem]?) -> Void) {
        db.collection("dictionaryItemLink").getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [DictionaryNameLinkUpdateItem] = []
                for document in querySnapshot?.documents ?? [] {
                    do {
                        let post = try Firestore.Decoder().decode(DictionaryNameLinkUpdateItem.self, from: document.data())
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
    func loadMonsterLinks(completion: @escaping ([DictionaryNameLinkUpdateItem]?) -> Void) {
        db.collection("dictionaryMonsterLink").getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [DictionaryNameLinkUpdateItem] = []
                for document in querySnapshot?.documents ?? [] {
                    do {
                        let post = try Firestore.Decoder().decode(DictionaryNameLinkUpdateItem.self, from: document.data())
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
    func loadItem(itemName: String, completion: @escaping (DictionaryItem?) -> Void) {
        db.collection("dictionaryItems").document(itemName).getDocument { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                do {
                    let post = try Firestore.Decoder().decode(DictionaryItem.self, from: querySnapshot?.data())
                    completion(post)
                } catch {
                    completion(nil)
                    return
                }
            }
        }
    }
    func loadMonster(monsterName: String, completion: @escaping (DictionaryMonster?) -> Void) {
        db.collection("dictionaryMonsters").document(monsterName).getDocument { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                do {
                    let post = try Firestore.Decoder().decode(DictionaryMonster.self, from: querySnapshot?.data())
                    completion(post)
                } catch {
                    completion(nil)
                    return
                }
            }
        }
    }
}

