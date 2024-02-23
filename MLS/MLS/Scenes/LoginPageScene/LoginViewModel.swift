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
}

// MARK: - Methods
extension LoginViewModel {
    func trySignIn(email: String, password: String, completion: @escaping ((TextState, TextState)) -> Void) {
        var result: (TextState, TextState) = (.normal, .normal)
        switch email {
        case "":
            result.0 = .emailBlank
        case "email":
            result.0 = .normal
        default:
            result.0 = .emailCheck
        }
        switch password {
        case "":
            result.1 = .pwBlank
        case "password":
            result.1 = .normal
        default:
            result.1 = .pwCheck
        }
        completion(result)
        //        Auth.auth().signIn(withEmail: email, password: password) { _, error in
        //            if error == nil {
        //                LoginManager.manager.email = Auth.auth().currentUser?.email
        //                completion(.normal)
        //            } else {
        //                completion(.normal)
        //            }
        //        }
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
