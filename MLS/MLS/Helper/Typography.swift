//
//  Typography.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

enum Typography {
    case bigTitle
    case title1
    case title2
    case title3
    case body1
    case body2
    case body3
    case button

    var font: UIFont {
        switch self {
        case .bigTitle:
            return .systemFont(ofSize: 40, weight: .bold)
        case .title1:
            return .systemFont(ofSize: 30, weight: .bold)
        case .title2:
            return .systemFont(ofSize: 18, weight: .bold)
        case .title3:
            return .systemFont(ofSize: 14, weight: .bold)
        case .body1:
            return .systemFont(ofSize: 18, weight: .regular)
        case .body2:
            return .systemFont(ofSize: 14, weight: .regular)
        case .body3:
            return .systemFont(ofSize: 12, weight: .light)
        case .button:
            return .systemFont(ofSize: 18, weight: .bold)
        }
    }
}

extension UIFont {
    static func customFont(fontSize: FontsSizeEnum, fontType: FontsTypeEnum) -> UIFont? {
        return UIFont(name: fontType.name, size: fontSize.size)
    }
}

enum FontsSizeEnum {
    
    case display_lg
    case display_sm
    case heading_lg
    case heading_md
    case heading_sm
    case body_lg
    case body_md
    case body_sm
    case caption_lg
    case caption_sm
    
    var size: CGFloat {
        switch self {
        case .display_lg:
            return 40
        case .display_sm:
            return 32
        case .heading_lg:
            return 28
        case .heading_md:
            return 24
        case .heading_sm:
            return 20
        case .body_lg:
            return 18
        case .body_md:
            return 16
        case .body_sm:
            return 14
        case .caption_lg:
            return 12
        case .caption_sm:
            return 10
        }
    }
}

enum FontsTypeEnum {
    
    case bold
    case semiBold
    case medium
    case regular
    
    var name: String {
        switch self {
        case .bold:
            return "Pretendard-Bold"
        case .semiBold:
            return "Pretendard-SemiBold"
        case .medium:
            return "Pretendard-Medium"
        case .regular:
            return "Pretendard-Regular"
        }
    }
}
