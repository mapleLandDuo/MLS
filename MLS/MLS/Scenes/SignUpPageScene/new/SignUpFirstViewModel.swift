//
//  SignInFirstViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

import Firebase

class SignUpFirstViewModel {
    // MARK: Properties
    var emailState: Observable<TextState> = Observable(nil)
    var firstPwState: Observable<TextState> = Observable(nil)
    var secondPwState: Observable<TextState> = Observable(nil)
    
    var isCorrect = false
    var isPrivacyAgree: Observable<Bool> = Observable(false)
    
    var checkPassword = [false, false, false, false]
    var rePassword: String?
}

// MARK: Methods
extension SignUpFirstViewModel {
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

    func checkPassword(password: String) {
            if password == "" {
                firstPwState.value = .pwBlank
                rePassword = password
                return
            }

            let lengthreg = ".{8,20}"
            let lengthtesting = NSPredicate(format: "SELF MATCHES %@", lengthreg)
            if lengthtesting.evaluate(with: password) == false {
                checkPassword[0] = false
                rePassword = password
                firstPwState.value = .pwOutOfBounds
            } else {
                checkPassword[0] = true
                rePassword = password
                firstPwState.value = .pwOutOfBounds
            }

            let specialCharactersPattern = ".*[$@$!%#?&].*"
            do {
                let regex = try NSRegularExpression(pattern: specialCharactersPattern)
                let range = NSRange(location: 0, length: password.utf16.count)
                if regex.firstMatch(in: password, options: [], range: range) != nil {
                    checkPassword[1] = true
                    rePassword = password
                    firstPwState.value = .pwNotSymbol
                } else {
                    checkPassword[1] = false
                    rePassword = password
                    firstPwState.value = .pwNotSymbol
                }
            } catch {
                print("Invalid regex: \(error.localizedDescription)")
            }

            let numbers = CharacterSet.decimalDigits
            if password.rangeOfCharacter(from: numbers) == nil {
                checkPassword[2] = false
                rePassword = password
                firstPwState.value = .pwNotInt
            } else {
                checkPassword[2] = true
                rePassword = password
                firstPwState.value = .pwNotInt
            }

            let letters = CharacterSet.letters
            if password.rangeOfCharacter(from: letters) == nil {
                checkPassword[3] = false
                rePassword = password
                firstPwState.value = .pwNotENG
            } else {
                checkPassword[3] = true
                rePassword = password
                firstPwState.value = .pwNotENG
            }

            if checkPassword.allSatisfy({ $0 == true }) {
                rePassword = password
                firstPwState.value = .complete
            }

            firstPwState.value = .complete
    }
    
    func reCheckPassword(password: String, checkPassword: String) {
        if password == "" {
            secondPwState.value = .pwBlank
            return
        }

        if password == checkPassword {
            secondPwState.value = .complete
        } else {
            secondPwState.value = .pwNotCorrect
        }
    }

    func isValidSignUp() -> Bool {
        if emailState.value == .complete && checkPassword.allSatisfy({ $0 == true }) && isPrivacyAgree.value == true {
            return true
        } else {
            return false
        }
    }
}
