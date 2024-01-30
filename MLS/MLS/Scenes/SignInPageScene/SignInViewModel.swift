//
//  SignInViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/18/24.
//

import Foundation
import FirebaseAuth

enum SignInResult {
    case emptyEmail
    case emptyPassword
    case fail
    case success
}

class SignInViewModel {
    // MARK: - Property
    var userDefaultManager = UserDefaultsManager()
    var isAutoLogin: Observable<Bool> = Observable(false)
    
    // MARK: - Method
    
    func passwordFind(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                print("send Email")
            } else {
                print("Email sending failed.")
            }
        }
    }
    
    func trySignIn(email: String, password: String, completion: @escaping (SignInResult) -> Void) {
        if email == "" {
            completion(.emptyEmail)
            return
        }
        if password == "" {
            completion(.emptyPassword)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if error == nil {
                Utils.currentUser = Auth.auth().currentUser?.email
                completion(.success)
            } else {
                completion(.fail)
            }
        }
    }
}
