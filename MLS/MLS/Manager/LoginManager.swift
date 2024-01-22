//
//  LoginManager.swift
//  MLS
//
//  Created by SeoJunYoung on 1/22/24.
//

import Foundation
import FirebaseAuth

class LoginManager {
    
    private let users: String = "users"
    private let PostBooks: String = "PostBooks"
    let email = Auth.auth().currentUser?.email
    
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
        
//        let userData = User(email: email, nickName: nickName, PostBooks: [])
//        do {
//            let data = try Firestore.Encoder().encode(userData)
//            db.collection(users).document(email).setData(data)
//            completion(true, nil)
//        } catch {
//            completion(false,"FirebaseManager_EncodeFail")
//        }
    }
}
