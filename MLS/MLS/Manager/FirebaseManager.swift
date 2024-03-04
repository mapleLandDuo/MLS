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

// 에러처리 봐야함
// 통일가능한 메서드는 제네릭을 이용해서 통일 ex) fetchData -> 컬렉션 따라 가능하게
// 진훈

enum CollectionName: String {
    case users = "users"
    case posts = "posts"
    case comments = "comments"
    
    case dictionaryItems = "dictionaryItems"
    case dictionaryMonsters = "dictionaryMonsters"
    case dictionaryMaps = "dictionaryMaps"
    case dictionaryNPCs = "dictionaryNPCs"
    case dictionaryQuests = "dictionaryQuests"
    
    case dictionaryItemLink = "dictionaryItemLink"
    case dictionaryMonstersLink = "dictionaryMonsterLink"
    case dictionaryMapLink = "dictionaryMapLink"
    case dictionaryNPCLink = "dictionaryNPCLink"
    case dictionaryQuestLink = "dictionaryQuestLink"
    
    case dictVersion = "dictVersion"
    
    case userDatas = "userDatas"
}

class FirebaseManager {
    static let firebaseManager = FirebaseManager()

    private init() {}
    
    let db = Firestore.firestore()
}

extension FirebaseManager {
    // MARK: User

    func fetchNickname(userEmail: String, completion: @escaping (String?) -> Void) {
        db.collection(CollectionName.users.rawValue).document(userEmail).getDocument { document, error in
            if let error = error {
                print("닉네임 가져오지 못함: \(error)")
                completion(nil)
            } else if let document = document, document.exists {
                let name = document.get("nickName") as? String
                completion(name)
            } else {
                print("닉네임 가져오지 못함")
                completion(nil)
            }
        }
    }
    
    func checkNickNameExist(nickName: String, completion: @escaping (Bool?) -> Void) {
        db.collection(CollectionName.userDatas.rawValue).whereField("nickName", isEqualTo: nickName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("닉네임 가져오지 못함: \(error)")
                completion(false)
            } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                completion(true)
            } else {
                print("닉네임 가져오지 못함")
                completion(false)
            }
        }
    }
    
    func checkEmailExist(email: String, completion: @escaping (Bool?) -> Void) {
        db.collection(CollectionName.userDatas.rawValue).document(email).getDocument { document, error in
            if let error = error {
                print("이메일 가져오지 못함: \(error)")
                completion(false)
            } else if let document = document, document.exists {
                completion(true)
            } else {
                print("이메일 가져오지 못함")
                completion(false)
            }
        }
    }
    
    func saveUser(email: String, nickName: String, completion: @escaping (_ isSuccess: Bool, _ errorMessage: String?) -> Void) {
        let userData = User(id: email, nickName: nickName, state: .normal, blockingPosts: [], blockingComments: [], blockingUsers: [], blockedUsers: [])
        do {
            let data = try Firestore.Encoder().encode(userData)
            db.collection(CollectionName.users.rawValue).document(email).setData(data)
            completion(true, nil)
        } catch {
            completion(false, "FirebaseManager_EncodeFail")
        }
    }
    
    func saveUserData(user: User, completion: @escaping (_ isSuccess: Bool, _ errorMessage: String?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(user)
            db.collection(CollectionName.userDatas.rawValue).document(user.id).setData(data)
            completion(true, nil)
        } catch {
            print(false, "FirebaseManager_EncodeFail")
        }
    }
    
    func deleteUserData(email: String, completion: @escaping () -> Void) {
        fetchUserPosts(userEmail: email) { posts in
            guard let posts = posts else { return }
            let ids = posts.map { $0.id }
            for id in ids {
                self.deletePost(postID: id.uuidString) { print("delete") }
            }
            self.db.collection(CollectionName.users.rawValue).document(email).delete { _ in
                completion()
            }
        }
    }
}

extension FirebaseManager {
    // MARK: Post

    func savePost(post: Post) {
        do {
            let data = try Firestore.Encoder().encode(post)
            db.collection(CollectionName.posts.rawValue).document(post.id.uuidString).setData(data)
        } catch {
            print(error)
        }
    }

    // 게시글 전부 가져오기
    func fetchPosts(type: [BoardSeparatorType], completion: @escaping ([Post]?) -> Void) {
        db.collection(CollectionName.posts.rawValue).whereField("postType", in: type.map { $0.rawValue }).order(by: "date", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [Post] = []
                let group = DispatchGroup()

                for document in querySnapshot?.documents ?? [] {
                    group.enter()
                    do {
                        let post = try Firestore.Decoder().decode(Post.self, from: document.data())
                        if let myEmail = LoginManager.manager.email {
                            self.fetchMyReportUsers { users in
                                if let users = users {
                                    if !(post.reports.contains(myEmail)), !users.contains(post.user) {
                                        posts.append(post)
                                    }
                                    group.leave()
                                }
                            }
                        } else {
                            posts.append(post)
                            group.leave()
                        }
                    } catch {
                        completion(nil)
                        group.leave()
                        return
                    }
                }

                group.notify(queue: .main) {
                    completion(posts)
                }
            }
        }
    }

    // 게시글 id로 가져오기
    func fetchPost(id: String, completion: @escaping (Post?) -> Void) {
        db.collection(CollectionName.posts.rawValue).document(id).getDocument { documentSnapshot, error in
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

    // 게시글 개수로 가져오기
    func fetchPosts(type: [BoardSeparatorType], itemCount: Int, completion: @escaping ([Post]?) -> Void) {
        db.collection(CollectionName.posts.rawValue).whereField("postType", in: type.map { $0.rawValue }).order(by: "date", descending: true).limit(to: itemCount + 3).getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [Post] = []
                let group = DispatchGroup()

                for document in querySnapshot?.documents ?? [] {
                    group.enter()
                    do {
                        let post = try Firestore.Decoder().decode(Post.self, from: document.data())
                        if let myEmail = LoginManager.manager.email {
                            self.fetchMyReportUsers { users in
                                if let users = users {
                                    if !(post.reports.contains(myEmail)), !users.contains(post.user) {
                                        posts.append(post)
                                    }
                                    group.leave()
                                }
                            }
                        } else {
                            posts.append(post)
                            group.leave()
                        }
                    } catch {
                        completion(nil)
                        group.leave()
                        return
                    }
                }

                group.notify(queue: .main) {
                    completion(Array(posts.prefix(itemCount)))
                }
            }
        }
    }

    // 본인 게시글 가져오기
    func fetchUserPosts(userEmail: String, completion: @escaping ([Post]?) -> Void) {
        db.collection(CollectionName.posts.rawValue).whereField("user", isEqualTo: userEmail).order(by: "date", descending: true).getDocuments { querySnapshot, error in
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
                        print("decoding Fail")
                        completion(nil)
                        return
                    }
                }
                completion(posts)
            }
        }
    }

    func updatePost(post: Post) {
        do {
            let data = try Firestore.Encoder().encode(post)
            db.collection(CollectionName.posts.rawValue).document(post.id.uuidString).updateData(data)
        } catch {
            print(error)
        }
    }

    func deletePost(postID: String, completion: @escaping () -> Void) {
        db.collection(CollectionName.posts.rawValue).document(postID).delete { error in
            if let error = error {
                print("게시글 삭제 실패: \(error)")
            } else {
                completion()
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

    func toCompletePost(postID: String, completion: @escaping () -> Void) {
        db.collection(CollectionName.posts.rawValue).document(postID).updateData([
            "postType": BoardSeparatorType.complete.rawValue
        ])
        completion()
    }
}

extension FirebaseManager {
    // MARK: Comment

    func saveComment(postID: String, comment: Comment, completion: @escaping () -> Void) {
        do {
            let data = try Firestore.Encoder().encode(comment)
            db.collection(CollectionName.posts.rawValue).document(postID).collection("comments").document(comment.id.uuidString).setData(data)
            completion()
        } catch {
            print(error)
        }
    }

    // 게시글 댓글 가져오기
    func fetchComments(postID: String, completion: @escaping ([Comment]?) -> Void) {
        db.collection(CollectionName.posts.rawValue).document(postID).collection(CollectionName.comments.rawValue).order(by: "date", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
                completion(nil)
            } else {
                var comments: [Comment] = []
                let group = DispatchGroup()

                for document in querySnapshot?.documents ?? [] {
                    group.enter()
                    do {
                        let comment = try Firestore.Decoder().decode(Comment.self, from: document.data())
                        if let myEmail = LoginManager.manager.email {
                            self.fetchMyReportUsers { users in
                                if let users = users {
                                    if !(comment.reports.contains(myEmail)), !users.contains(comment.user) {
                                        comments.append(comment)
                                    }
                                    group.leave()
                                }
                            }
                        } else {
                            comments.append(comment)
                            group.leave()
                        }
                    } catch {
                        completion(nil)
                        group.leave()
                        return
                    }
                }

                group.notify(queue: .main) {
                    completion(comments)
                }
            }
        }
    }

    // 유저 댓글 가져오기
    func fetchUserComments(userID: String, completion: @escaping ([Comment]?) -> Void) {
        db.collection(CollectionName.posts.rawValue).getDocuments { postQuerySnapshot, postError in
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

                let commentsQuery = self.db.collection(CollectionName.posts.rawValue ).document(postID).collection(CollectionName.comments.rawValue).whereField("user", isEqualTo: userID).order(by: "date", descending: true)

                commentsQuery.getDocuments { commentsQuerySnapshot, commentsError in
                    if let commentsError = commentsError {
                        print("댓글을 가져오지 못했습니다: \(commentsError)")
                        dispatchGroup.leave()
                        return
                    }

                    for document in commentsQuerySnapshot?.documents ?? [] {
                        do {
                            let comment = try Firestore.Decoder().decode(Comment.self, from: document.data())
                            guard let myEmail = LoginManager.manager.email else { return }
                            if !(comment.reports.contains(myEmail)) {
                                comments.append(comment)
                            }
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

    func updateComment(postID: String, comment: Comment, completion: @escaping () -> Void) {
        do {
            let data = try Firestore.Encoder().encode(comment)
            db.collection(CollectionName.posts.rawValue).document(postID).collection(CollectionName.comments.rawValue).document(comment.id.uuidString).updateData(data)
            completion()
        } catch {}
    }

    func deleteComment(postID: String, commentID: String, completion: @escaping () -> Void) {
        db.collection(CollectionName.posts.rawValue).document(postID).collection(CollectionName.comments.rawValue).document(commentID).delete { error in
            if let error = error {
                print("댓글 삭제 실패: \(error)")
            } else {
                print("댓글 삭제 성공")
                completion()
            }
        }
    }
}

extension FirebaseManager {
    // MARK: ItemSearch/MonsterSearch

    func searchData<T: Decodable>(name: String, type: T.Type, completion: @escaping ([T]?) -> Void) {
        let collectionName = getCollectionName(for: type)
        db.collection(collectionName).order(by: "name").whereField("name", isGreaterThanOrEqualTo: name).whereField("name", isLessThanOrEqualTo: name + "\u{f8ff}").getDocuments { querySnapshot, err in
            if let err = err {
                print("검색 데이터 없음: \(err)")
                completion(nil)
            } else {
                do {
                    var results: [T] = []
                    for document in querySnapshot!.documents {
                        let data = try Firestore.Decoder().decode(T.self, from: document.data())
                        results.append(data)
                    }
                    completion(results)
                } catch {
                    print("검색 데이터 디코딩 실패: \(error)")
                    completion(nil)
                }
            }
        }
    }

    func fetchItemsByRoll(roll: String, completion: @escaping ([DictionaryItem]) -> Void) {
        db.collection(CollectionName.dictionaryItems.rawValue)
            .whereField("detailDescription.직업", isGreaterThanOrEqualTo: roll)
            .whereField("detailDescription.직업", isLessThanOrEqualTo: roll + "\u{f8ff}").order(by: "detailDescription.직업").order(by: "level")
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("검색 데이터 없음: \(err)")
                } else {
                    do {
                        var results = [DictionaryItem]()
                        for document in querySnapshot!.documents {
                            let data = try Firestore.Decoder().decode(DictionaryItem.self, from: document.data())
                            results.append(data)
                        }
                        completion(results)
                    } catch {
                        print("검색 데이터 디코딩 실패: \(error)")
                    }
                }
            }
    }

    func fetchMonstersByLevel(minLevel: Int, maxLevel: Int, completion: @escaping ([DictionaryMonster]) -> Void) {
        db.collection(CollectionName.dictionaryMonsters.rawValue).whereField("level", isGreaterThanOrEqualTo: minLevel).whereField("level", isLessThanOrEqualTo: maxLevel).order(by: "level")
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("검색 데이터 없음: \(err)")
                } else {
                    do {
                        var results = [DictionaryMonster]()
                        for document in querySnapshot!.documents {
                            let data = try Firestore.Decoder().decode(DictionaryMonster.self, from: document.data())
                            results.append(data)
                        }
                        completion(results)
                    } catch {
                        print("검색 데이터 디코딩 실패: \(error)")
                    }
                }
            }
    }

    func getCollectionName<T>(for type: T.Type) -> String {
        switch type {
        case is DictionaryItem.Type:
            return CollectionName.dictionaryItems.rawValue
        case is DictionaryMonster.Type:
            return CollectionName.dictionaryMonsters.rawValue
        default:
            return "defaultCollection"
        }
    }
}

// MARK: - Dictionary
extension FirebaseManager {

    func updateDictionaryLink(collection: CollectionName, documentName: String, item: DictionaryNameLinkUpdateItem, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(item)
            db.collection(collection.rawValue).document(documentName).setData(data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }

    func fetchLinks(collectionName: CollectionName, completion: @escaping ([DictionaryNameLinkUpdateItem]?) -> Void) {
        db.collection(collectionName.rawValue).getDocuments { querySnapshot, error in
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
    
    func dictVersionUpdate(dictVersion: DictVersion, completion: @escaping (String) -> Void) {
        do {
            var count = 0
            for (i, item) in dictVersion.items.enumerated() {
                let encodingItem = try Firestore.Encoder().encode(dictVersion.items[i])
                db.collection(CollectionName.dictVersion.rawValue).document(dictVersion.version).collection("items").document(item.name).setData(encodingItem)
                count += 1
            }
            for (i, monster) in dictVersion.monsters.enumerated() {
                let encodingMonster = try Firestore.Encoder().encode(dictVersion.monsters[i])
                db.collection(CollectionName.dictVersion.rawValue).document(dictVersion.version).collection("monsters").document(monster.name).setData(encodingMonster)
                count += 1
            }
            for (i, map) in dictVersion.maps.enumerated() {
                let encodingMap = try Firestore.Encoder().encode(dictVersion.maps[i])
                db.collection(CollectionName.dictVersion.rawValue).document(dictVersion.version).collection("maps").document(map.name).setData(encodingMap)
                count += 1
            }
            for (i, npc) in dictVersion.npcs.enumerated() {
                let encodingNPC = try Firestore.Encoder().encode(dictVersion.npcs[i])
                db.collection(CollectionName.dictVersion.rawValue).document(dictVersion.version).collection("npcs").document(npc.name).setData(encodingNPC)
                count += 1
            }
            for (i, quest) in dictVersion.quests.enumerated() {
                let encodingQuest = try Firestore.Encoder().encode(dictVersion.quests[i])
                db.collection(CollectionName.dictVersion.rawValue).document(dictVersion.version).collection("quests").document(quest.name).setData(encodingQuest)
                count += 1
            }
            completion("\(count): update")
        } catch {
            completion(error.localizedDescription)
        }
    }
    
    func fetchDatas<T: Decodable>(colName: String, completion: @escaping ([T]?) -> Void) {
        db.collection(CollectionName.dictVersion.rawValue).document("V1.0.2").collection(colName).getDocuments { querySnapshot, err in
            if let err = err {
                print("검색 데이터 없음: \(err)")
                completion(nil)
            } else {
                do {
                    var results: [T] = []
                    for document in querySnapshot!.documents {
                        let data = try Firestore.Decoder().decode(T.self, from: document.data())
                        results.append(data)
                    }
                    completion(results)
                } catch {
                    print("검색 데이터 디코딩 실패: \(error)")
                    completion(nil)
                }
            }
        }
    }
}

// MARK: - 지울 예정
extension FirebaseManager {
    func fetchItems(itemName: String, completion: @escaping (DictionaryItem?) -> Void) {
         db.collection(CollectionName.dictionaryItems.rawValue).document(itemName).getDocument { querySnapshot, error in
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

     func fetchMonsters(monsterName: String, completion: @escaping (DictionaryMonster?) -> Void) {
         db.collection(CollectionName.dictionaryMonsters.rawValue).document(monsterName).getDocument { querySnapshot, error in
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

extension FirebaseManager {
    // MARK: Report

    func reportUser(userID: String, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        guard let myEmail = LoginManager.manager.email else { return }

        db.collection(CollectionName.users.rawValue).document(userID).getDocument { document, error in
            if let document = document, document.exists {
                guard let blockedUsers = document.get("blockedUsers") as? [String] else { return }
                if blockedUsers.contains(myEmail) {
                    group.enter()
                    self.db.collection(CollectionName.users.rawValue).document(userID).updateData([
                        "blockedUsers": FieldValue.arrayRemove([myEmail])
                    ]) { error in
                        if let error = error {
                            print("상대방 데이터에서 기존 내 아이디 삭제 실패 \(error)")
                        }
                        group.leave()
                    }
                } else {
                    group.enter()
                    self.db.collection(CollectionName.users.rawValue).document(userID).updateData([
                        "blockedUsers": FieldValue.arrayUnion([myEmail])
                    ]) { error in
                        if let error = error {
                            print("상대방 데이터에 내 아이디 저장 실패 \(error)")
                        }
                        group.leave()
                    }
                }
            } else {
                print("문서가 존재하지 않습니다.")
            }
        }

        group.enter()
        db.collection(CollectionName.users.rawValue).document(myEmail).updateData([
            "blockingUsers": FieldValue.arrayUnion([userID])
        ]) { error in
            if error != nil {
                print("내 목록 업데이트 실패")
            }
        }
        group.leave()

        group.notify(queue: .main) {
            completion()
        }
    }

    func reportPost(postID: String, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        guard let myEmail = LoginManager.manager.email else { return }

        db.collection(CollectionName.posts.rawValue).document(postID).getDocument { document, error in
            if let document = document, document.exists {
                guard let reports = document.get("reports") as? [String] else { return }
                if reports.contains(myEmail) {
                    group.enter()
                    self.db.collection(CollectionName.posts.rawValue).document(postID).updateData([
                        "reports": FieldValue.arrayRemove([myEmail])
                    ]) { error in
                        if let error = error {
                            print("상대방 데이터에서 기존 내 아이디 삭제 실패 \(error)")
                        }
                        group.leave()
                    }
                } else {
                    group.enter()
                    self.db.collection(CollectionName.posts.rawValue).document(postID).updateData([
                        "reports": FieldValue.arrayUnion([myEmail])
                    ]) { error in
                        if let error = error {
                            print("상대방 데이터에 내 아이디 저장 실패 \(error)")
                        }
                        group.leave()
                    }
                }
            } else {
                print("문서가 존재하지 않습니다.")
            }
        }

        group.enter()
        db.collection(CollectionName.users.rawValue).document(myEmail).updateData([
            "blockingPosts": FieldValue.arrayUnion([postID])
        ]) { error in
            if error != nil {
                print("내 목록 업데이트 실패")
            }
        }
        group.leave()

        group.notify(queue: .main) {
            completion()
        }
    }

    func reportComment(postId: String, commentId: String, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        guard let myEmail = LoginManager.manager.email else { return }

        db.collection(CollectionName.posts.rawValue).document(postId).collection(CollectionName.comments.rawValue).document(commentId).getDocument { document, error in
            if let document = document, document.exists {
                guard let reports = document.get("reports") as? [String] else { return }
                if reports.contains(myEmail) {
                    group.enter()
                    self.db.collection(CollectionName.posts.rawValue).document(postId).collection(CollectionName.comments.rawValue).document(commentId).updateData([
                        "reports": FieldValue.arrayRemove([myEmail])
                    ]) { error in
                        if let error = error {
                            print("상대방 데이터에서 기존 내 아이디 삭제 실패 \(error)")
                        }
                        group.leave()
                    }
                } else {
                    group.enter()
                    self.db.collection(CollectionName.posts.rawValue).document(postId).collection(CollectionName.comments.rawValue).document(commentId).updateData([
                        "reports": FieldValue.arrayUnion([myEmail])
                    ]) { error in
                        if let error = error {
                            print("상대방 데이터에 내 아이디 저장 실패 \(error)")
                        }
                        group.leave()
                    }
                }
            } else {
                print("문서가 존재하지 않습니다.")
            }
        }

        group.enter()
        db.collection(CollectionName.users.rawValue).document(myEmail).updateData([
            "blockingComments": FieldValue.arrayUnion([commentId])
        ]) { error in
            if error != nil {
                print("내 목록 업데이트 실패")
            }
        }
        group.leave()

        group.notify(queue: .main) {
            completion()
        }
    }

    func reportComment(postId: String, commentId: String, newReport: [String], completion: @escaping () -> Void) {
        let group = DispatchGroup()

        group.enter()
        db.collection(CollectionName.posts.rawValue).document(postId).collection(CollectionName.comments.rawValue).document(commentId).updateData([
            "reports": newReport
        ]) { error in
            if error != nil {
                print("업데이트 실패")
            } else {
                completion()
            }
        }
        group.leave()

        group.notify(queue: .main) {
            completion()
        }
    }

    func fetchMyReportUsers(completion: @escaping ([String]?) -> Void) {
        guard let myEmail = LoginManager.manager.email else { return }
        db.collection(CollectionName.users.rawValue).document(myEmail).getDocument { documentSnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                if let document = documentSnapshot, document.exists {
                    do {
                        let user = try Firestore.Decoder().decode(User.self, from: document.data())
                        completion(user.blockingUsers)
                    } catch {
                        print("데이터를 디코딩하는데 실패했습니다: \(error)")
                        completion(nil)
                    }
                } else {
                    print("문서가 존재하지 않습니다.")
                    completion(nil)
                }
            }
        }
    }
}

extension FirebaseManager {
    // UpCount
    func updateLikeCount(postID: String, completion: @escaping () -> Void) {
        guard let myEmail = LoginManager.manager.email else { return }
        db.collection(CollectionName.posts.rawValue).document(postID).getDocument { document, error in
            if let document = document, document.exists {
                guard let reports = document.get("likes") as? [String] else { return }
                if reports.contains(myEmail) {
                    self.db.collection(CollectionName.posts.rawValue).document(postID).updateData([
                        "likes": FieldValue.arrayRemove([myEmail])
                    ]) { error in
                        if let error = error {
                            print("상대방 데이터에서 기존 내 아이디 삭제 실패 \(error)")
                        } else {
                            completion()
                        }
                    }
                } else {
                    self.db.collection(CollectionName.posts.rawValue).document(postID).updateData([
                        "likes": FieldValue.arrayUnion([myEmail])
                    ]) { error in
                        if let error = error {
                            print("상대방 데이터에 내 아이디 저장 실패 \(error)")
                        } else {
                            completion()
                        }
                    }
                }
            } else {
                print("문서가 존재하지 않습니다.")
            }
        }
    }
}

extension FirebaseManager {
    // MARK: ViewCount

    func updateViewCount(postID: String) {
        db.collection(CollectionName.posts.rawValue).document(postID).updateData([
            "viewCount": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("뷰카운트 증가 실패: \(error)")
            }
        }
    }
}

extension FirebaseManager {
    // MARK: PostSearch

    func searchPosts(text: String, completion: @escaping ([Post]?) -> Void) {
        db.collection(CollectionName.posts.rawValue).whereField("title", isGreaterThanOrEqualTo: text).whereField("title", isLessThan: text + "\u{f8ff}").order(by: "title").order(by: "date", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [Post] = []
                let group = DispatchGroup()

                for document in querySnapshot?.documents ?? [] {
                    group.enter()
                    do {
                        let post = try Firestore.Decoder().decode(Post.self, from: document.data())
                        if let myEmail = LoginManager.manager.email {
                            self.fetchMyReportUsers { users in
                                if let users = users {
                                    if !(post.reports.contains(myEmail)), !users.contains(post.user) {
                                        posts.append(post)
                                    }
                                    group.leave()
                                }
                            }
                        } else {
                            posts.append(post)
                            group.leave()
                        }
                    } catch {
                        completion(nil)
                        group.leave()
                        return
                    }
                }

                group.notify(queue: .main) {
                    completion(posts)
                }
            }
        }
    }
}

extension FirebaseManager {
    // MARK: SortedPost

    func fetchNewPosts(type: [BoardSeparatorType], completion: @escaping ([Post]?) -> Void) {
        db.collection(CollectionName.posts.rawValue).whereField("postType", in: type.map { $0.rawValue }).order(by: "date", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [Post] = []
                let group = DispatchGroup()

                for document in querySnapshot?.documents ?? [] {
                    group.enter()
                    do {
                        let post = try Firestore.Decoder().decode(Post.self, from: document.data())
                        if let myEmail = LoginManager.manager.email {
                            self.fetchMyReportUsers { users in
                                if let users = users {
                                    if !(post.reports.contains(myEmail)), !users.contains(post.user) {
                                        posts.append(post)
                                    }
                                    group.leave()
                                }
                            }
                        } else {
                            posts.append(post)
                            group.leave()
                        }
                    } catch {
                        completion(nil)
                        group.leave()
                        return
                    }
                }

                group.notify(queue: .main) {
                    completion(posts)
                }
            }
        }
    }

    func fetchPopularPosts(type: [BoardSeparatorType], completion: @escaping ([Post]?) -> Void) {
        db.collection(CollectionName.posts.rawValue).whereField("postType", in: type.map { $0.rawValue }).order(by: "viewCount", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("데이터를 가져오지 못했습니다: \(error)")
                completion(nil)
            } else {
                var posts: [Post] = []
                let group = DispatchGroup()

                for document in querySnapshot?.documents ?? [] {
                    group.enter()
                    do {
                        let post = try Firestore.Decoder().decode(Post.self, from: document.data())
                        if let myEmail = LoginManager.manager.email {
                            self.fetchMyReportUsers { users in
                                if let users = users {
                                    if !(post.reports.contains(myEmail)), !users.contains(post.user) {
                                        posts.append(post)
                                    }
                                    group.leave()
                                }
                            }
                        } else {
                            posts.append(post)
                            group.leave()
                        }
                    } catch {
                        completion(nil)
                        group.leave()
                        return
                    }
                }

                group.notify(queue: .main) {
                    completion(posts)
                }
            }
        }
    }
}

// MARK: - DictSearchCount
extension FirebaseManager {
    
    func countUpDictSearch(type: DictType, name: String) {
        
        db.collection(type.collectionName).document(name).getDocument { [weak self] querySnapshot, error in
            if error == nil {
                if querySnapshot?.data() == nil {
                    do {
                        let searchCountData = DictNameCount(name: name, count: 1)
                        let data = try Firestore.Encoder().encode(searchCountData)
                        self?.db.collection(type.collectionName).document(name).setData(data)
                    } catch {
                        print(error)
                    }
                } else {
                    self?.db.collection(type.collectionName).document(name).updateData([
                        "count": FieldValue.increment(Int64(1))
                    ]) { error in
                        if let error = error {
                            print("카운트 증가 실패: \(error)")
                        } else {
                            print("카운트 증가 성공")
                        }
                    }
                }
            }
        }
        
    }
    
    func fetchDictSearchCount(type: DictType , completion: @escaping ([DictNameCount]) -> Void) {
        db.collection(type.collectionName).getDocuments { querySnapshot, error in
            do {
                guard let documents = querySnapshot?.documents else { return }
                var datas = try Firestore.Decoder().decode([DictNameCount].self, from: documents.map({$0.data()}))
                datas.sort { first, second in
                    return first.count > second.count
                }
                completion(datas)
            } catch {
                print(error)
                completion([])
            }
        }
    }
}


