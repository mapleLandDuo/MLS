//
//  LoginViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

import FirebaseAuth

class LoginViewModel {
    // MARK: - Properties
    var userDefaultManager = UserDefaultsManager()

    var isAutoLogin: Observable<Bool> = Observable(false)
}

// MARK: - Methods
extension LoginViewModel {
    func trySignIn(email: String, password: String, completion: @escaping ((TextState, TextState)) -> Void) {
        print(email, password)
        var result: (TextState, TextState) = (.default, .default)

        if email == "" {
            result.0 = .emailBlank
        }

        if password == "" {
            result.1 = .pwBlank
        }

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error == nil {
                LoginManager.manager.email = Auth.auth().currentUser?.email
                result.0 = .complete
                result.1 = .complete
            } else {
                if let error = error as? NSError {
                    switch error.code {
                    case 17008:
                        result.0 = .emailCheck
                    case 17004:
                        result.1 = .pwCheck
                    default:
                        print(error)
                    }
                }
            }
            completion(result)
        }
    }

    func setAutoLogIn(isAuto: Bool) {
        switch isAuto {
        case true:
            break
        case false:
            break
        }
    }
}
