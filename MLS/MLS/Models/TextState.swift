//
//  t.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/12.
//

import Foundation

enum TextState: CustomStringConvertible {
    case `default`
    case complete
    case emailCheck
    case emailBlank
    case pwCheck
    case pwBlank
    case pwOutOfBounds
    case pwNotENG
    case pwNotInt
    case pwNotSymbol
    case pwNotCorrect
    case emailExist
    case nickNameExist
    case nickNameNotCorrect
    case lvNotInt
    case lvOutOfBounds

    var description: String {
        switch self {
        case .default, .complete:
            return ""
        case .emailCheck:
            return "이메일을 다시 확인해주세요."
        case .emailBlank:
            return "이메일을 입력해주세요."
        case .pwCheck:
            return "비밀번호를 다시 확인해주세요."
        case .pwBlank:
            return "비밀번호를 입력해주세요."
        case .pwOutOfBounds, .pwNotENG, .pwNotInt, .pwNotSymbol:
            return "비밀번호 조건을 만족시켜주세요."
        case .pwNotCorrect:
            return "비밀번호가 일치하지 않아요."
        case .emailExist:
            return "이미 가입된 이메일이에요."
        case .nickNameExist:
            return "중복된 닉네임이에요."
        case .nickNameNotCorrect:
            return "닉네임을 2~8자로 지어주세요."
        case .lvNotInt:
            return "숫자만 입력해주세요."
        case .lvOutOfBounds:
            return "1~200 사잇값만 넣어주세요."
        }
    }
}
