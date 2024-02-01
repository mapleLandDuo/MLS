//
//  Constants.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//
import UIKit

enum Constants {
    struct Default {
        let vertical: CGFloat = 12
        let horizontal: CGFloat = 16
        let radius: CGFloat = 8
        let blockHeight: CGFloat = UIScreen.main.bounds.height * 0.06
    }

    static let defaults = Default()
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}
