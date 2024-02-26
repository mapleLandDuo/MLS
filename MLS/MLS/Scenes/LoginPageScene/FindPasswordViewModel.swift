//
//  FindPasswordViewModel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/23.
//

import Foundation

class FindPasswordViewModel {
    
}

// MARK: Methods
extension FindPasswordViewModel {
    func checkEmailValidation(email: String, completion: @escaping (CustomButtonType) -> Void) {
        completion(email == "email" ? CustomButtonType.clickabled : CustomButtonType.disabled)
    }
    
    func checkEmailExist(email: String, completion: @escaping (Bool) -> Void) {
        completion(email == "email.com")
    }
}
