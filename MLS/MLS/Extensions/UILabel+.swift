//
//  UILabel+.swift
//  MLS
//
//  Created by SeoJunYoung on 1/15/24.
//

import UIKit

extension UILabel {
    func startTextFlowAnimation(withDuration: Double = 5, superViewWidth: CGFloat) {
        UIView.animate(withDuration: withDuration, delay: 0.0, options: [.beginFromCurrentState, .repeat], animations: {
            let labelWidth = self.intrinsicContentSize.width
            let moveValue = labelWidth - superViewWidth
            if superViewWidth < labelWidth {
                self.transform = CGAffineTransform(
                    translationX: self.bounds.origin.x - moveValue - 30, y: self.bounds.origin.y
                )
            }
        }, completion: nil)
    }
}
