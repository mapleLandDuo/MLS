//
//  SignInSecondViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

import FirebaseAuth

class SignUpSecondViewModel {
    // MARK: Properties
    var nickNameState: TempObservable<TextState> = TempObservable(.default)
    var levelState: TempObservable<TextState> = TempObservable(.default)
    var isAccountExist: TempObservable<Bool> = TempObservable(nil)
    var job: TempObservable<Job> = TempObservable(nil)

    var user = User(id: "", nickName: "", state: .normal, blockingPosts: [], blockingComments: [], blockingUsers: [], blockedUsers: [])
    var password = ""
}

// MARK: Methods
extension SignUpSecondViewModel {
    func checkNickName(nickName: String) {
        if nickName != "" {
            FirebaseManager.firebaseManager.checkNickNameExist(nickName: nickName) { [weak self] isExist in
                guard let isExist = isExist else { return }
                if isExist {
                    self?.nickNameState.value = .nickNameExist
                } else if !(2 ... 8).contains(nickName.count) {
                    self?.nickNameState.value = .nickNameNotCorrect
                } else {
                    self?.nickNameState.value = .complete
                }
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

    func trySignUp(email: String, password: String, nickName: String, completion: @escaping (_ isSuccess: Bool, _ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            if error == nil {
                guard let user = self?.user else { return }
                FirebaseManager.firebaseManager.saveUserData(user: user) { isSuccess, errorMessage in
                    if isSuccess {
                        completion(true, nil)
                    } else {
                        completion(false, errorMessage)
                    }
                }
            } else {
                completion(false, error?.localizedDescription)
            }
        }
    }
}
