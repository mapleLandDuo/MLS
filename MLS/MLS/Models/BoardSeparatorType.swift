//
//  BoardSeparatorType.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/16.
//

import Foundation

enum BoardSeparatorType: String, Codable {
    case normal
    case sell = "팝니다"
    case buy = "삽니다"
    case complete = "거래완료"
}
