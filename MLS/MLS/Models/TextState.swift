//
//  t.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/12.
//

import Foundation

enum TextState: String {
    case `default`
    case complete
    case emailCheck = "이메일을 다시 확인해주세요."
    case emailBlank = "이메일을 입력해주세요."
    case pwCheck = "비밀번호를 다시 확인해주세요."
    case pwBlank = "비밀번호를 입력해주세요."
    case pwOutOfBounds
    case pwNotENG
    case pwNotInt
    case pwNotSymbol
    case pwNotCorrect = "비밀번호가 일치하지 않아요"
    case emailExist = "이미 가입된 이메일이에요."
    case nickNameExist = "중복된 닉네임이에요."
    case nickNameNotCorrect = "닉네임을 2~8자로 지어주세요"
    case lvNotInt = "숫자만 입력해주세요"
    case lvOutOfBounds = "1~200 사잇값만 넣어주세요"
}
