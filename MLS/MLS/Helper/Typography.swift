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
    case title2Medium
    case title3
    case body1
    case body2
    case body3
    case commentBook
    case commentMy
    
    var font: UIFont {
        switch self {
        case .bigTitle:
            return .systemFont(ofSize: 40, weight: .bold)
        case .title1:
            return .systemFont(ofSize: 30, weight: .bold)
        case .title2:
            return .systemFont(ofSize: 24, weight: .regular)
        case .title2Medium:
            return .systemFont(ofSize: 24, weight: .medium)
        case .title3:
            return .systemFont(ofSize: 20, weight: .regular)
        case .body1:
            return .systemFont(ofSize: 18, weight: .regular)
        case .body2:
            return .systemFont(ofSize: 14, weight: .regular)
        case .body3:
            return .systemFont(ofSize: 12, weight: .light)
        case .commentBook:
            return .systemFont(ofSize: 48, weight: .medium)
        case .commentMy:
            return .systemFont(ofSize: 28, weight: .regular)
        }
    }
}
