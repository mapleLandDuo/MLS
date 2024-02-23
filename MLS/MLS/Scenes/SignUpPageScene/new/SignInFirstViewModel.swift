//
//  SignInFirstViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

class SignInFirstViewModel {
    // MARK: Properties
    var emailState: Observable<TextState> = Observable(nil)
    var firstPwState: Observable<TextState> = Observable(nil)
    var secondPwState: Observable<TextState> = Observable(nil)
}

// MARK: Methods
extension SignInFirstViewModel {
    func checkForm(text: String, type: TextFieldType, completion: @escaping (TextState) -> Void) {
        switch type {
        case .normal:
            if text == "email" {
                completion(.normal)
            } else if text == "" {
                completion(.emailBlank)
            } else if text == "이미 가입" {
                completion(.emailExist)
            } else {
                completion(.emailCheck)
            }
        case .password:
            if text == "password" {
                completion(.normal)
            } else if text == "" {
                completion(.pwBlank)
            } else {
                completion(.pwCheck)
            }
        }
    }
}
