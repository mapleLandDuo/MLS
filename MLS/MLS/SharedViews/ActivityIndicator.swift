//
//  ActivityIndicator.swift
//  MLS
//
//  Created by SeoJunYoung on 1/23/24.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {
    init() {
        super.init(frame: .zero)
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.color = .systemOrange
        self.hidesWhenStopped = true
        self.style = .medium
        self.stopAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
