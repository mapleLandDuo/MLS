//
//  MyPageEditViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 3/1/24.
//

import Foundation

class MyPageEditViewModel {
    
    let nickNameState: TempObservable<TextState> = TempObservable(.default)
    let levelState: TempObservable<TextState> = TempObservable(.default)
    let jobState: TempObservable<Job?> = TempObservable(nil)
    let buttonState: TempObservable<Bool> = TempObservable(false)
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
            nickNameState.value = .complete
            return
        }
        
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
    
    func isValidButton() {
        if nickNameState.value != .complete {
            buttonState.value = false
            return
        }
        if levelState.value != .complete {
            buttonState.value = false
            return
        }
        if jobState.value == nil {
            buttonState.value = false
            return
        }
        buttonState.value = true
    }
}
