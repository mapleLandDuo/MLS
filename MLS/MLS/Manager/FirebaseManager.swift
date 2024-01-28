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

    func savePost(post: Post, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(post)
            db.collection("posts").document(post.id.uuidString).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }

    func loadPosts(completion: @escaping ([Post]?) -> Void) {
        db.collection("posts").getDocuments { querySnapshot, error in
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
    
    func saveImages(images: [UIImage?], completion: @escaping (URL?) -> Void) {
        images.forEach { image in
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.3) else { return }
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let imageName = "\(UUID().uuidString) + \(String(Date().toString()))"
            let firebaseReference = Storage.storage().reference().child("PostImages").child("\(imageName)")
            firebaseReference.putData(imageData, metadata: metaData) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("성공")
                    firebaseReference.downloadURL { url, _ in
                        completion(url)
                    }
                }
            }
        }
    }
}

extension FirebaseManager  {
    func saveDictionaryItemLink(item: DictionaryItemLink, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(item)
            db.collection("dictionaryItemLink").document(item.name).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func saveDictionaryMonster(item: DictionaryMonster, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(item)
            db.collection("dictionaryMonster").document(item.name).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    func saveDictionaryItem(item: DictionaryItem, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(item)
            db.collection("dictionaryItem").document(item.name).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func loadLinks(completion: @escaping ([DictionaryItemLink]?) -> Void) {
        db.collection("dictionaryItemLink").getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [DictionaryItemLink] = []
                for document in querySnapshot?.documents ?? [] {
                    do {
                        let post = try Firestore.Decoder().decode(DictionaryItemLink.self, from: document.data())
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
}
