//
//  UIColor+.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

extension UIColor {
    
    static var semanticColor = SemanticColor()
    static var jobBadgeColor = JobBadgeColor()
    
    static func themeColor(color: ThemeColor, value: ColorValueEnum) -> UIColor? {
        return UIColor(named: color.rawValue + value.rawValue)
    }
    
    static func primitiveColor(color: PrimitiveColor, value: ColorValueEnum) -> UIColor? {
        return UIColor(named: color.rawValue + value.rawValue)
    }
}

enum PrimitiveColor: String {
    case orange = "Orange_"
    case brown = "Brown_"
    case green = "Green_"
    case blue = "Blue_"
    case yellow = "Yellow_"
    case red = "Red_"
    case gray = "Gray_"
    case pure = ""
}

enum ThemeColor: String {
    case brand_primary = "Orange_"
    case brand_secondary = "Brown_"
    case success = "Green_"
    case info = "Blue_"
    case warning = "Yellow_"
    case distructive = "Red_"
    case neutral = "Gray_"
    case base = ""
}

enum ColorValueEnum: String {
    case value_50 = "50"
    case value_100 = "100"
    case value_200 = "200"
    case value_300 = "300"
    case value_400 = "400"
    case value_500 = "500"
    case value_600 = "600"
    case value_700 = "700"
    case value_800 = "800"
    case value_900 = "900"
    case value_950 = "950"
    case value_white = "White"
    case value_black = "Black"
}

struct SemanticColor {
    var text = SemanticTextColor()
    var icon = SemanticIconColor()
    var bg = SemanticBgColor()
    var bolder = SemanticBolderColor()
}

struct SemanticTextColor {
    var primary: UIColor? = .themeColor(color: .neutral, value: .value_950)
    var secondary: UIColor? = .themeColor(color: .neutral, value: .value_400)
    var tertiary: UIColor? = .themeColor(color: .neutral, value: .value_300)
    var info_bold: UIColor? = .themeColor(color: .info, value: .value_600)
    var info: UIColor? = .themeColor(color: .info, value: .value_500)
    var warning_bold: UIColor? = .themeColor(color: .warning, value: .value_600)
    var warning: UIColor? = .themeColor(color: .warning, value: .value_500)
    var success_bold: UIColor? = .themeColor(color: .success, value: .value_600)
    var success: UIColor? = .themeColor(color: .success, value: .value_500)
    var distructive_bold: UIColor? = .themeColor(color: .distructive, value: .value_600)
    var distructive: UIColor? = .themeColor(color: .distructive, value: .value_500)
    var interactive = SemanticTextInteractiveColor()
}

struct SemanticTextInteractiveColor {
    var primary: UIColor? = .themeColor(color: .brand_primary, value: .value_500)
    var primary_hovered: UIColor? = .themeColor(color: .brand_primary, value: .value_600)
    var primary_pressed: UIColor? = .themeColor(color: .brand_primary, value: .value_700)
    var secondary: UIColor? = .themeColor(color: .neutral, value: .value_100)
    var secondary_hovered: UIColor? = .themeColor(color: .neutral, value: .value_200)
    var secondary_pressed: UIColor? = .themeColor(color: .neutral, value: .value_300)
    var selected: UIColor? = .themeColor(color: .brand_primary, value: .value_500)
    var inverse: UIColor? = .themeColor(color: .base, value: .value_white)
}

struct SemanticIconColor {
    var primary: UIColor? = .themeColor(color: .neutral, value: .value_950)
    var secondary: UIColor? = .themeColor(color: .neutral, value: .value_400)
    var tertiary: UIColor? = .themeColor(color: .neutral, value: .value_300)
    var info_bold: UIColor? = .themeColor(color: .info, value: .value_500)
    var info: UIColor? = .themeColor(color: .info, value: .value_600)
    var warning_bold: UIColor? = .themeColor(color: .warning, value: .value_500)
    var warning: UIColor? = .themeColor(color: .warning, value: .value_600)
    var success_bold: UIColor? = .themeColor(color: .success, value: .value_500)
    var success: UIColor? = .themeColor(color: .success, value: .value_600)
    var distructive_bold: UIColor? = .themeColor(color: .distructive, value: .value_500)
    var distructive: UIColor? = .themeColor(color: .distructive, value: .value_600)
    var interactive = SemanticIconInteractiveColor()
}

struct SemanticIconInteractiveColor {
    var primary: UIColor? = .themeColor(color: .brand_primary, value: .value_500)
    var primary_hovered: UIColor? = .themeColor(color: .brand_primary, value: .value_600)
    var primary_pressed: UIColor? = .themeColor(color: .brand_primary, value: .value_700)
    var secondary: UIColor? = .themeColor(color: .neutral, value: .value_100)
    var secondary_hovered: UIColor? = .themeColor(color: .neutral, value: .value_200)
    var secondary_pressed: UIColor? = .themeColor(color: .neutral, value: .value_300)
    var selected: UIColor? = .themeColor(color: .brand_primary, value: .value_500)
    var inverse: UIColor? = .themeColor(color: .base, value: .value_white)
}

struct SemanticBgColor {
    var primary: UIColor? = .themeColor(color: .neutral, value: .value_50)
    var secondary: UIColor? = .themeColor(color: .neutral, value: .value_100)
    var tertiary: UIColor? = .themeColor(color: .neutral, value: .value_200)
    var brand: UIColor? = .themeColor(color: .brand_primary, value: .value_400)
    var info_bold: UIColor? = .themeColor(color: .info, value: .value_100)
    var info: UIColor? = .themeColor(color: .info, value: .value_50)
    var warning_bold: UIColor? = .themeColor(color: .warning, value: .value_100)
    var warning: UIColor? = .themeColor(color: .warning, value: .value_50)
    var success_bold: UIColor? = .themeColor(color: .success, value: .value_100)
    var success: UIColor? = .themeColor(color: .success, value: .value_50)
    var distructive_bold: UIColor? = .themeColor(color: .distructive, value: .value_100)
    var distructive: UIColor? = .themeColor(color: .distructive, value: .value_50)
    var disabled: UIColor? = .themeColor(color: .neutral, value: .value_300)
    var interactive = SemanticBgInteractiveColor()
}

struct SemanticBgInteractiveColor {
    var primary: UIColor? = .themeColor(color: .brand_primary, value: .value_400)
    var primary_hovered: UIColor? = .themeColor(color: .brand_primary, value: .value_500)
    var primary_pressed: UIColor? = .themeColor(color: .brand_primary, value: .value_600)
    var secondary: UIColor? = .themeColor(color: .neutral, value: .value_500)
    var secondary_hovered: UIColor? = .themeColor(color: .neutral, value: .value_700)
    var secondary_pressed: UIColor? = .themeColor(color: .neutral, value: .value_900)
}

struct SemanticBolderColor {
    var primary: UIColor? = .themeColor(color: .neutral, value: .value_100)
    var secondary: UIColor? = .themeColor(color: .neutral, value: .value_200)
    var tertiary: UIColor? = .themeColor(color: .neutral, value: .value_300)
    var info_bold: UIColor? = .themeColor(color: .info, value: .value_300)
    var info: UIColor? = .themeColor(color: .info, value: .value_100)
    var warning_bold: UIColor? = .themeColor(color: .warning, value: .value_500)
    var warning: UIColor? = .themeColor(color: .warning, value: .value_400)
    var success_bold: UIColor? = .themeColor(color: .success, value: .value_600)
    var success: UIColor? = .themeColor(color: .success, value: .value_500)
    var distructive_bold: UIColor? = .themeColor(color: .distructive, value: .value_500)
    var distructive: UIColor? = .themeColor(color: .distructive, value: .value_400)
    var disabled: UIColor? = .themeColor(color: .neutral, value: .value_400)
    var interactive = SemanticBolderInteractiveColor()
}

struct SemanticBolderInteractiveColor {
    var primary: UIColor? = .themeColor(color: .brand_primary, value: .value_400)
    var primary_hovered: UIColor? = .themeColor(color: .brand_primary, value: .value_500)
    var primary_pressed: UIColor? = .themeColor(color: .brand_primary, value: .value_600)
    var secondary: UIColor? = .themeColor(color: .neutral, value: .value_700)
    var secondary_hovered: UIColor? = .themeColor(color: .neutral, value: .value_800)
    var secondary_pressed: UIColor? = .themeColor(color: .neutral, value: .value_900)
}

struct JobBadgeColor {
    var warrior = UIColor(named: "Warrior")
    var thief = UIColor(named: "Thief")
    var archer = UIColor(named: "Archer")
    var mage = UIColor(named: "Mage")
}
