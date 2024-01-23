//
//  LoginManager.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

class LoginManager {
    
    private let db = Firestore.firestore()
    private let users: String = "users"
    private let PostBooks: String = "PostBooks"
    let email = Auth.auth().currentUser?.email
    
    func isLogin() -> Bool {
        return Auth.auth().currentUser == nil ? false : true
    }
    
    func deleteUser(email: String) {
        Auth.auth().currentUser?.delete()
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
        
        let userData = User(id: email, nickName: nickName, state: .normal, blockedPost: [], blockedCommtent: [], blockedUser: [])
        do {
            let data = try Firestore.Encoder().encode(userData)
            db.collection(users).document(email).setData(data)
            completion(true, nil)
        } catch {
            completion(false,"FirebaseManager_EncodeFail")
        }
    }
}
