//
//  CustomLabel.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import UIKit

class CustomLabel: UILabel {
    private var padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

    init(text: String, textColor: UIColor? = .black, font: UIFont?, padding: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.padding = padding
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
