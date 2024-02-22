//
//  CustomButton.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/22.
//

import UIKit

class CustomButton: UIButton {
    init(text: String, textColor: UIColor?, textFont: UIFont?, backgroundColor: UIColor? = .semanticColor.bg.disabled, borderColor: UIColor?, radius: CGFloat = 12) {
        super.init(frame: .zero)
        setUp(text: text, textColor: textColor, textFont: textFont, backgroundColor: backgroundColor, borderColor: borderColor, radius: radius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(text: String, textColor: UIColor?, textFont: UIFont?, backgroundColor: UIColor?, borderColor: UIColor?, radius: CGFloat) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = textFont
        self.titleLabel?.textAlignment = .center
        self.backgroundColor = backgroundColor
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 1
        }
        self.layer.cornerRadius = radius
    }
}
