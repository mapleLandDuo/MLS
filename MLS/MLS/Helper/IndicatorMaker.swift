//
//  IndicatorMaker.swift
//  MLS
//
//  Created by SeoJunYoung on 1/23/24.
//

import UIKit

enum IndicatorMaker {
    static let loadingIndicatorView = ActivityIndicator()

    static func showLoading() {
        DispatchQueue.main.async {
            guard let vc = UIApplication.shared.keyWindow?.visibleViewController else { return }

            vc.view.addSubview(loadingIndicatorView)
            loadingIndicatorView.center = vc.view.center
            loadingIndicatorView.frame = vc.view.frame
            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let vc = UIApplication.shared.keyWindow?.visibleViewController else { return }
            loadingIndicatorView.removeFromSuperview()
        }
    }
}
