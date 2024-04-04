//
//  SignInSecondViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxSwift

class SignUpSecondViewModel {
    // MARK: Properties
    var nickNameState = BehaviorRelay<TextState>(value: .default)
    var levelState = BehaviorRelay<TextState>(value: .default)
    var isAccountExist = BehaviorRelay<Bool?>(value: nil)
    var job = BehaviorRelay<Job?>(value: nil)
    let disposeBag = DisposeBag()
    
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
                    self?.nickNameState.accept(.nickNameExist)
                } else if !(2 ... 8).contains(nickName.count) {
                    self?.nickNameState.accept(.nickNameNotCorrect)
                } else {
                    self?.nickNameState.accept(.complete)
                }
            }
        } else {
            nickNameState.accept(.default)
        }
    }

    func checkLevel(level: String) {
        if level == "" {
            levelState.accept(.default)
        } else {
            if let level = Int(level) {
                if 1 ... 200 ~= level {
                    levelState.accept(.complete)
                } else {
                    levelState.accept(.lvOutOfBounds)
                }
            } else {
                levelState.accept(.lvNotInt)
            }
        }
    }
    
    func isComplete() -> Observable<Bool> {
        Observable.combineLatest(isAccountExist.asObservable().map{ $0 ?? false }, nickNameState, levelState, job.startWith(nil))
            .map { isAccountExist, nickNameState, levelState, job in
                if isAccountExist {
                    return nickNameState != .default && levelState != .default && job != nil
                } else {
                    return nickNameState != .default
                }
            }
            .distinctUntilChanged()
    }
    
    func isValidSignUp() -> Observable<TextState> {
        return Observable.create { observer in
            guard let isAccountExist = self.isAccountExist.value else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            if self.nickNameState.value == .nickNameExist {
                observer.onNext(.nickNameExist)
            } else if self.nickNameState.value == .nickNameNotCorrect {
                observer.onNext(.nickNameNotCorrect)
            } else if isAccountExist, self.levelState.value == .lvNotInt {
                observer.onNext(.lvNotInt)
            } else if isAccountExist, self.levelState.value == .lvOutOfBounds {
                observer.onNext(.lvOutOfBounds)
            } else {
                observer.onNext(.complete)
            }

            observer.onCompleted()
            return Disposables.create()
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
