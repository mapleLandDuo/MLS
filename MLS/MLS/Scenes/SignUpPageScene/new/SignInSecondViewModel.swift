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
                // 존재
                completion((.nickNameExist, false))
            } else if (2 ... 8).contains(nickName.count) {
                // 형식
                completion((.nickNameNotCorrect, false))
            } else {
                // 성공
                completion((.complete, true))
            }
        } else {
            // 형식
            completion((.nickNameNotCorrect, false))
        }
    }
    
    func checkLevel(level: String, completion: @escaping ((TextState, Bool)) -> Void) {
        if let level = Int(level) {
            if 1...200 ~= level {
                completion((.complete, true))
            } else {
                completion((.lvOutOfBounds, false))
            }
        } else {
            completion((.lvNotInt, false))
        }
    }
}
