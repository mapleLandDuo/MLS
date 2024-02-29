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
        var result: (TextState, TextState) = (.default, .default)
        switch email {
        case "":
            result.0 = .emailBlank
        case "email":
            result.0 = .complete
        default:
            result.0 = .emailCheck
        }
        switch password {
        case "":
            result.1 = .pwBlank
        case "password":
            result.1 = .complete
        default:
            result.1 = .pwCheck
        }
        completion(result)
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
