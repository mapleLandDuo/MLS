//
//  SignInFirstViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

import Firebase
import RxCocoa
import RxSwift

class SignUpFirstViewModel {
    // MARK: Properties
//    var emailState: TempObservable<TextState> = TempObservable(nil)
//    var firstPwState: TempObservable<TextState> = TempObservable(nil)
//    var secondPwState: TempObservable<TextState> = TempObservable(nil)
    var emailState = BehaviorRelay<TextState?>(value: nil)
    var firstPwState = BehaviorRelay<TextState?>(value: nil)
    var secondPwState = BehaviorRelay<TextState?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    var isCorrect = false
//    var isPrivacyAgree: TempObservable<Bool> = TempObservable(false)
    var isPrivacyAgree = BehaviorRelay<Bool>(value: false)
    
    var checkPassword = [false, false, false, false]
    var rePassword: String?
}

// MARK: Methods
extension SignUpFirstViewModel {
    func checkEmail(email: String) {
        if email == "" {
            emailState.accept(.emailBlank)
            isCorrect = false
            return
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            Firestore.firestore().collection(CollectionName.userDatas.rawValue).getDocuments { [weak self] data, error in
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                } else {
                    guard let safeData = data else { return }
                    if safeData.documents.map({ $0.documentID }).contains(email) {
                        self?.isCorrect = false
                        self?.emailState.accept(.emailExist)
                        return
                    } else {
                        self?.isCorrect = true
                        self?.emailState.accept(.complete)
                        return
                    }
                }
            }
        } else {
            isCorrect = false
            emailState.accept(.emailCheck)
            return
        }
    }

    func checkPassword(password: String) {
            if password == "" {
                firstPwState.accept(.pwBlank)
                rePassword = password
                return
            }

            let lengthreg = ".{8,20}"
            let lengthtesting = NSPredicate(format: "SELF MATCHES %@", lengthreg)
            if lengthtesting.evaluate(with: password) == false {
                checkPassword[0] = false
                rePassword = password
                firstPwState.accept(.pwOutOfBounds)
            } else {
                checkPassword[0] = true
                rePassword = password
                firstPwState.accept(.pwOutOfBounds)
            }

            let specialCharactersPattern = ".*[$@$!%#?&].*"
            do {
                let regex = try NSRegularExpression(pattern: specialCharactersPattern)
                let range = NSRange(location: 0, length: password.utf16.count)
                if regex.firstMatch(in: password, options: [], range: range) != nil {
                    checkPassword[1] = true
                    rePassword = password
                    firstPwState.accept(.pwNotSymbol)
                } else {
                    checkPassword[1] = false
                    rePassword = password
                    firstPwState.accept(.pwNotSymbol)
                }
            } catch {
                print("Invalid regex: \(error.localizedDescription)")
            }

            let numbers = CharacterSet.decimalDigits
            if password.rangeOfCharacter(from: numbers) == nil {
                checkPassword[2] = false
                rePassword = password
                firstPwState.accept(.pwNotInt)
            } else {
                checkPassword[2] = true
                rePassword = password
                firstPwState.accept(.pwNotInt)
            }

            let letters = CharacterSet.letters
            if password.rangeOfCharacter(from: letters) == nil {
                checkPassword[3] = false
                rePassword = password
                firstPwState.accept(.pwNotENG)
            } else {
                checkPassword[3] = true
                rePassword = password
                firstPwState.accept(.pwNotENG)
            }

            if checkPassword.allSatisfy({ $0 == true }) {
                rePassword = password
                firstPwState.accept(.complete)
            }

            firstPwState.accept(.complete)
    }
    
    /// 비밀번호 재확인 메소드
    /// - Parameters:
    ///   - password: 비밀번호
    ///   - checkPassword: 재확인 비밀번호
    func reCheckPassword(password: String, checkPassword: String) {
        if password == "" {
            secondPwState.accept(.pwBlank)
            return
        }

        if password == checkPassword {
            secondPwState.accept(.complete)
        } else {
            secondPwState.accept(.pwNotCorrect)
        }
    }
    
    /// 올바른 모든 정보를 입력받았는지를 확인하는 메소드
    /// - Returns: 올바른 모든 정보면 true, 부족한 정보가 있으면 false
    func isValidSignUp() -> Bool {
        if emailState.value == .complete && checkPassword.allSatisfy({ $0 == true }) && isPrivacyAgree.value == true {
            return true
        } else {
            return false
        }
    }
}
