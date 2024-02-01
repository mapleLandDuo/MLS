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
