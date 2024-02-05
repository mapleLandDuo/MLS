//
//  InsetTextField.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

class InsetTextField: UITextField {
    // MARK: - Properties
    private let commonInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    
    private let clearButtonOffset: CGFloat = 5
    
    private let clearButtonLeftPadding: CGFloat = 5

    // MARK: - Override Methods

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }

    // clearButton의 위치와 크기를 고려해 inset을 삽입
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let editingInsets = UIEdgeInsets(
            top: commonInsets.top,
            left: commonInsets.left,
            bottom: commonInsets.bottom,
            right: clearButtonWidth + clearButtonOffset + clearButtonLeftPadding
        )
        return bounds.inset(by: editingInsets)
    }

    // clearButtonOffset만큼 x축 이동
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearButtonRect = super.clearButtonRect(forBounds: bounds)
        clearButtonRect.origin.x -= clearButtonOffset
        return clearButtonRect
    }
}
