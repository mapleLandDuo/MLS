//
//  Typography.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

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
