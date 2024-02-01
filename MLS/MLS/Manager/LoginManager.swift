//
//  LoginManager.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import Foundation

import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

class LoginManager {
    private let db = Firestore.firestore()
    private let users: String = "users"
    private let PostBooks: String = "PostBooks"
    let email = Auth.auth().currentUser?.email
    
    func isLogin() -> Bool {
        return Auth.auth().currentUser == nil ? false : true
    }
    
    func deleteUser(completion: @escaping () -> Void) {
        Auth.auth().currentUser?.delete(completion: { _ in
            completion()
        })
    }
    
    func logOut(completion: @escaping (_ isLogOut: Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func createUser(email: String, nickName: String, completion: @escaping (_ isSuccess: Bool, _ errorMessage: String?) -> Void) {
        let userData = User(id: email, nickName: nickName, state: .normal, blockingPosts: [], blockingComments: [], blockingUsers: [], blockedUsers: [])
        do {
            let data = try Firestore.Encoder().encode(userData)
            db.collection(users).document(email).setData(data)
            completion(true, nil)
        } catch {
            completion(false, "FirebaseManager_EncodeFail")
        }
    }
}
