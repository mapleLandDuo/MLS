//
//  SignInFirstViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

import Firebase

class SignInFirstViewModel {
    // MARK: Properties
    var emailState: Observable<TextState> = Observable(nil)
    var firstPwState: Observable<TextState> = Observable(nil)
    var secondPwState: Observable<TextState> = Observable(nil)
    var isCorrect = false
    var checkPassword = [false, false, false, false]
}

// MARK: Methods
extension SignInFirstViewModel {
    func checkEmail(email: String) {
        if email == "" {
            emailState.value = .emailBlank
            isCorrect = false
            return
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            Firestore.firestore().collection("users").getDocuments { [weak self] data, error in
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                } else {
                    guard let safeData = data else { return }
                    if safeData.documents.map({ $0.documentID }).contains(email) {
                        self?.isCorrect = false
                        self?.emailState.value = .emailExist
                        return
                    } else {
                        self?.isCorrect = true
                        self?.emailState.value = .complete
                        return
                    }
                }
            }
        } else {
            isCorrect = false
            emailState.value = .emailCheck
            return
        }
    }

    func checkPassword(password: String, title: String) {
        if title == "비밀번호" {
            if password == "" {
                firstPwState.value = .pwBlank
                return
            }

            let lengthreg = ".{8,20}"
            let lengthtesting = NSPredicate(format: "SELF MATCHES %@", lengthreg)
            if lengthtesting.evaluate(with: password) == false {
                checkPassword[0] = false
                firstPwState.value = .pwOutOfBounds
            } else {
                checkPassword[0] = true
                firstPwState.value = .pwOutOfBounds
            }

            let specialCharactersPattern = ".*[$@$!%#?&].*"
            do {
                let regex = try NSRegularExpression(pattern: specialCharactersPattern)
                let range = NSRange(location: 0, length: password.utf16.count)
                if regex.firstMatch(in: password, options: [], range: range) != nil {
                    checkPassword[1] = true
                    firstPwState.value = .pwNotSymbol
                } else {
                    checkPassword[1] = false
                    firstPwState.value = .pwNotSymbol
                }
            } catch {
                print("Invalid regex: \(error.localizedDescription)")
            }

            let numbers = CharacterSet.decimalDigits
            if password.rangeOfCharacter(from: numbers) == nil {
                checkPassword[2] = false
                firstPwState.value = .pwNotInt
            } else {
                checkPassword[2] = true
                firstPwState.value = .pwNotInt
            }

            let letters = CharacterSet.letters
            if password.rangeOfCharacter(from: letters) == nil {
                checkPassword[3] = false
                firstPwState.value = .pwNotENG
            } else {
                checkPassword[3] = true
                firstPwState.value = .pwNotENG
            }

            if checkPassword.allSatisfy({ $0 == true }) {
                firstPwState.value = .complete
            }

            firstPwState.value = .complete
        } else if title == "비밀번호 재확인" {
            if password == "" {
                isCorrect = false
                secondPwState.value = .pwBlank
                return
            }
        }
    }

//    func isValidEmail(email: String) {
//        if email.count == 0 {
//            emailState.value = .emailBlank
//            return
//        }
//
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//        if emailTest.evaluate(with: email) {
//            Firestore.firestore().collection("users").getDocuments { data, error in
//                if error != nil {
//                    print(String(describing: error?.localizedDescription))
//                } else {
//                    guard let safeData = data else { return }
//                    if safeData.documents.map({ $0.documentID }).contains(email) {
//                        self.emailState.value = .emailExist
//                    } else {
//                        self.emailState.value = .complete
//                    }
//                }
//            }
//        } else {
//            emailState.value = .emailCheck
//        }
//    }

//    func isValidPassword(password: String) {
//        if password.count == 0 {
//            passwordState.value = .empty
//            return
//        }
//        let lengthreg = ".{8,20}"
//        let lengthtesting = NSPredicate(format: "SELF MATCHES %@", lengthreg)
//        if lengthtesting.evaluate(with: password) == false {
//            passwordState.value = .length
//            return
//        }
//        let combinationreg = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
//        let combinationtesting = NSPredicate(format: "SELF MATCHES %@", combinationreg)
//        if combinationtesting.evaluate(with: password) == false {
//            passwordState.value = .combination
//            return
//        }
//        let specialreg = "^(?=.*[!@#$%^&*()_+=-]).{8,20}"
//        let specialtesting = NSPredicate(format: "SELF MATCHES %@", specialreg)
//        if specialtesting.evaluate(with: password) == false {
//            passwordState.value = .special
//            return
//        }
//        passwordState.value = .available
//    }
}
