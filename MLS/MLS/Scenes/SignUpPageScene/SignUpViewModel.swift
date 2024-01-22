//
//  SignUpViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum ValidationResult {
    case empty
    case checking
    case available
    case alreadyInUse
    case unavailableFormat
    case length
    case combination
    case special
    case unconformity
}

class SignUpViewModel {
    // MARK: - Property
    var emailState: Observable<ValidationResult> = Observable(.empty)
    var nickNameState: Observable<ValidationResult> = Observable(.empty)
    var passwordState: Observable<ValidationResult> = Observable(.empty)
    var checkPasswordState: Observable<ValidationResult> = Observable(.empty)
    var isPrivacyAgree: Observable<Bool> = Observable(false)
    var isSignUpAble: Observable<Bool> = Observable(false)
    var firebaseManager = FirebaseManager()
}

extension SignUpViewModel {
    // MARK: - Method

    func trySignUp(email: String, password: String, nickName: String) {
        Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func isValidEmail(email: String) {
        if email.count == 0 {
            emailState.value = .empty
            return
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            emailState.value = .checking
//            Firestore.firestore().collection("users").getDocuments { data, error in
//                if error != nil {
//                    print("[FirebaseManager][\(#function)]: \(String(describing: error?.localizedDescription))")
//                } else {
//                    guard let safeData = data else { return }
//                    if safeData.documents.map({$0.documentID}).contains(email) {
//                        self.emailState.value = .alreadyInUse
//                    } else {
//                        self.emailState.value = .available
//                    }
//                }
//            }
            self.emailState.value = .available
        } else {
            emailState.value = .unavailableFormat
        }
    }
    
    func isValidNickName(nickName: String) {
        if nickName.count == 0 {
            nickNameState.value = .empty
            return
        }
        if (2 ... 8).contains(nickName.count) {
            nickNameState.value = .available
        } else {
            nickNameState.value = .length
        }
    }
    
    func isValidPassword(password: String) {
        if password.count == 0 {
            passwordState.value = .empty
            return
        }
        let lengthreg = ".{8,20}"
        let lengthtesting = NSPredicate(format: "SELF MATCHES %@", lengthreg)
        if lengthtesting.evaluate(with: password) == false {
            passwordState.value = .length
            return
        }
        let combinationreg = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
        let combinationtesting = NSPredicate(format: "SELF MATCHES %@", combinationreg)
        if combinationtesting.evaluate(with: password) == false {
            passwordState.value = .combination
            return
        }
        let specialreg = "^(?=.*[!@#$%^&*()_+=-]).{8,20}"
        let specialtesting = NSPredicate(format: "SELF MATCHES %@", specialreg)
        if specialtesting.evaluate(with: password) == false {
            passwordState.value = .special
            return
        }
        passwordState.value = .available
    }
    
    func isCheckPassword(password: String, checkPassword: String) {
        if password.count == 0 {
            checkPasswordState.value = .empty
            return
        }
        if password == checkPassword {
            checkPasswordState.value = .available
        } else {
            checkPasswordState.value = .unconformity
        }
    }
    
    func isValidSignUp() -> Bool {
        if emailState.value == .available
            && nickNameState.value == .available
            && passwordState.value == .available
            && checkPasswordState.value == .available
            && isPrivacyAgree.value == true {
            return true
        } else {
            return false
        }
    }
}
