//
//  LoginViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxSwift

class LoginViewModel {
    // MARK: - Properties
    var userDefaultManager = UserDefaultsManager()

    var isAutoLogin = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()
}

// MARK: - Methods
extension LoginViewModel {
    /// 로그인 요청을 보내는 메소드
    /// - Parameters:
    ///   - email: 이메일
    ///   - password: 비밀번호
    ///   - completion: 이메일 textField와 비밀번호 textField의 유효성 검사 결과를 completion으로 넘겨줌
    func trySignIn(email: String, password: String, completion: @escaping ((TextState, TextState)) -> Void) {
        var result: (TextState, TextState) = (.default, .default)

        if email == "" {
            result.0 = .emailBlank
        }

        if password == "" {
            result.1 = .pwBlank
        }

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error == nil {
                LoginManager.manager.email = Auth.auth().currentUser?.email
                result.0 = .complete
                result.1 = .complete
            } else {
                if let error = error as? NSError {
                    switch error.code {
                    case 17008:
                        result.0 = .emailCheck
                    case 17004:
                        result.1 = .pwCheck
                    default:
                        print(error)
                    }
                }
            }
            completion(result)
        }
    }

    func setAutoLogIn(isAuto: Bool) {
        switch isAuto {
        case true:
            break
        case false:
            break
        }
    }
    
    /// 이메일 유효성 검사이후 버튼의 활성화 상태를 리턴
    /// - Parameters:
    ///   - email: 이메일
    ///   - completion: 버튼 활성화 상태를 리턴
    func checkEmailValidation(email: String, completion: @escaping (CustomButtonType) -> Void) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            completion(.clickabled)
        } else {
            completion(.disabled)
        }
    }
    
    func checkEmailExist(email: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.firebaseManager.checkEmailExist(email: email) { isExist in
            guard let isExist = isExist else { return }
            completion(isExist)
        }
    }
    
    func findPassword(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                print("send Email")
                completion(true)
            } else {
                print("Email sending failed.")
                completion(false)
            }
        }
    }
}
