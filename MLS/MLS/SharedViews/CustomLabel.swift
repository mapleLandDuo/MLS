//
//  CustomLabel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import UIKit

class CustomLabel: UILabel {
    init(text: String, textColor: UIColor = .black, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
