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
    // MARK: - Properties
    
    static let manager = LoginManager()
    
    private init() {}
    
    private let users: String = "users"
    
    private let PostBooks: String = "PostBooks"
    
    var email = Auth.auth().currentUser?.email
}

// MARK: - Method
extension LoginManager {
    
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
            email = nil
            completion(true)
        } catch {
            completion(false)
        }
    }
}
