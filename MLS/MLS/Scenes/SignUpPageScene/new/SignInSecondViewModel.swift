//
//  SignInSecondViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

class SignInSecondViewModel {
    
}

// MARK: Methods
extension SignInSecondViewModel {
    func checkNickName(nickName: String, completion: @escaping ((TextState, Bool)) -> Void) {
        if nickName != "" {
            if nickName == "nickName" {
                completion((.nickNameExist, false))
            } else if nickName == "닉네임" {
                completion((.nickNameNotCorrect, false))
            } else {
                completion((.complete, true))
            }
        } else {
            completion((.nickNameNotCorrect, false))
        }
    }
    
    func checkLevel(level: String, completion: @escaping ((TextState, Bool)) -> Void) {
        if let level = Int(level) {
            if 1...200 ~= level {
                completion((.complete, true))
            } else {
                completion((.pwOutOfBounds, false))
            }
        } else {
            completion((.pwNotInt, false))
        }
    }
}
