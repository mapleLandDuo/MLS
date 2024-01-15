//
//  Constants.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//
import UIKit

struct Constants {
    struct Default {
        let vertical: CGFloat = 12
        let horizontal: CGFloat = 16
        let radius: CGFloat = 8
        let blockHeight: CGFloat = UIScreen.main.bounds.height * 0.05
    }
    static let defaults = Default()
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    enum PostType: String {
        case normal
        case sell = "팝니다"
        case buy = "삽니다"
        case complete = "거래완료"
    }
}


