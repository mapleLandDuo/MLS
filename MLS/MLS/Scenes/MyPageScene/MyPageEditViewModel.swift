//
//  MyPageEditViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 3/1/24.
//

import Foundation

import RxSwift
import RxCocoa

class MyPageEditViewModel {
    let nickNameState = BehaviorRelay<TextState>(value: .default)
    let levelState = BehaviorRelay<TextState>(value: .default)
    let jobState =  BehaviorRelay<Job?>(value: nil)
    let buttonState = BehaviorRelay<Bool>(value: false)
    var user: User
    private var originNickName: String
    
    init(user: User) {
        self.user = user
        originNickName = user.nickName
    }
}

extension MyPageEditViewModel {
    
    func fetchUser() -> User {
        return user
    }
    
    func checkNickName(nickName: String) {

        if originNickName == nickName {
            nickNameState.accept(.complete)
            return
        }
        
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
    
    func isValidButton() {
        if nickNameState.value != .complete {
            buttonState.accept(false)
            return
        }
        if levelState.value != .complete {
            buttonState.accept(false)
            return
        }
        if jobState.value == nil {
            buttonState.accept(false)
            return
        }
        buttonState.accept(true)
    }
}
