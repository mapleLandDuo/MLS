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
    var levelState: Observable<TextState> = Observable(nil)
    var isAccountExist: Observable<Bool> = Observable(nil)
    var job: Observable<Job> = Observable(nil)
    var user: User?
}

// MARK: Methods
extension SignInSecondViewModel {
    func checkNickName(nickName: String) {
        if nickName != "" {
//            if FirebaseManager.firebaseManager.checkNickNameExist() {
            if nickName == "nickName" {
                nickNameState.value = .nickNameExist
            } else if !(2 ... 8).contains(nickName.count) {
                nickNameState.value = .nickNameNotCorrect
            } else {
                nickNameState.value = .complete
            }
        } else {
            nickNameState.value = .default
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
    
    func isComplete(completion: @escaping (Bool) -> Void) {
        guard let isAccountExist = isAccountExist.value else {
            completion(false)
            return
        }
        if isAccountExist {
            guard nickNameState.value != .default else {
                completion(false)
                return
            }
            guard levelState.value != .default else {
                completion(false)
                return
            }
            guard job.value != nil else {
                completion(false)
                return
            }
        } else {
            guard nickNameState.value != .default else {
                completion(false)
                return
            }
        }
        completion(true)
    }
    
    func isValidSignUp(completion: @escaping (TextState) -> Void) {
        guard let isAccountExist = isAccountExist.value else { return }
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
