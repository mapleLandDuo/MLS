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
    // MARK: - Properties

    var userDefaultManager = UserDefaultsManager()
    
    var isAutoLogin: Observable<Bool> = Observable(false)
}

// MARK: - Methods
extension SignInViewModel {
    
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

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error == nil {
                LoginManager.manager.email = Auth.auth().currentUser?.email
                completion(.success)
            } else {
                completion(.fail)
            }
        }
    }
}
