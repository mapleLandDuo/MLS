//
//  Constants.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//
import UIKit

enum Constants {
    static let defaults = Default()
    static let spacings = Spacing()
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

struct Default {
    let vertical: CGFloat = 12
    let horizontal: CGFloat = 16
    let radius: CGFloat = 8
    let blockHeight: CGFloat = UIScreen.main.bounds.height * 0.06
}

struct Spacing {
    let xs_3: CGFloat = 1
    let xs_2: CGFloat = 2
    let xs: CGFloat = 4
    let sm: CGFloat = 8
    let md: CGFloat = 12
    let lg: CGFloat = 16
    let xl: CGFloat = 24
    let xl_2: CGFloat = 32
    let xl_3: CGFloat = 56
    let xl_4: CGFloat = 80
}
