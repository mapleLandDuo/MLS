//
//  AlertManage.swift
//  MLS
//
//  Created by SeoJunYoung on 3/2/24.
//

import UIKit

import SnapKit

enum AlertTypeEnum {
    case green
    case red
    case blue
    case yellow
    case gray
}

enum AlertLocationEnum {
    case bottom
    case center
}

class AlertManager {
    /// makeAlert
    /// - Parameters:
    ///   - vc: controller to use
    ///   - type: AlertTypeEnum( green, red, blue, yellow, gray)
    ///   - title: title
    ///   - description: description
    ///   - location: Alert Location
    ///
    static func showAlert(vc: UIViewController, type: AlertTypeEnum, title: String, description: String, location: AlertLocationEnum) {
        let backGroundView = AlertView(type: type, title: title, description: description)
        vc.view.addSubview(backGroundView)
        switch location {
        case .bottom:
            backGroundView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
                $0.bottom.equalTo(vc.view.safeAreaLayoutGuide).inset(86)
            }
        case .center:
            backGroundView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(Constants.spacings.xl)
                $0.center.equalToSuperview()
            }
        }
    }
}
