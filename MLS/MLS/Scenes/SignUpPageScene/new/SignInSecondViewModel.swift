//
//  SignInSecondViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

class SignInSecondViewModel {
    // MARK: Properties
    var nickNameState: Observable<TextState> = Observable(nil)
    var levelState: Observable<TextState> = Observable(.default)
    var isAccountExist: Bool?
    var job: Job?
    var user: User?
}

// MARK: Methods
extension SignInSecondViewModel {
    func checkNickName(nickName: String) {
        if nickName != "" {
//            if FirebaseManager.firebaseManager.checkNickNameExist() {
            if nickName == "nickName" {
                // 존재
                nickNameState.value = .nickNameExist
            } else if (2 ... 8).contains(nickName.count) {
                // 형식
                nickNameState.value = .nickNameNotCorrect
            } else {
                // 성공
                nickNameState.value = .complete
            }
        } else {
            // 형식
            nickNameState.value = .nickNameExist
        }
    }

    func checkLevel(level: String) {
        if level == "" {
            levelState.value = .default
        } else {
            if let level = Int(level) {
                if 1 ... 200 ~= level {
                    levelState.value = .complete
                } else {
                    levelState.value = .lvOutOfBounds
                }
            } else {
                levelState.value = .lvNotInt
            }
        }
    }
    
    func checkAccount(completion: @escaping (TextState) -> Void) {
        if isAccountExist == nil {
            // 계정 유무 선택 필요
            completion(.default)
        } else if !checkJob() {
            // 직업 고르기
            completion(.default)
        } else {
            isValidSignUp() { state in
                completion(state)
            }
        }
    }
    
    func checkJob() -> Bool {
        return job != nil
    }
    
    func isValidSignUp(completion: @escaping(TextState) -> Void) {
        guard let isAccountExist = isAccountExist else { return }
        if nickNameState.value == .nickNameExist {
            completion(.nickNameExist)
        } else if nickNameState.value == .nickNameNotCorrect {
            completion(.nickNameNotCorrect)
        } else if isAccountExist, levelState.value == .lvNotInt {
            completion(.lvNotInt)
        } else if isAccountExist, levelState.value == .lvOutOfBounds {
            completion(.lvOutOfBounds)
        } else {
            completion(.complete)
        }
    }
}
