//
//  PopUpMaker.swift
//  MLS
//
//  Created by SeoJunYoung on 2/21/24.
//

import UIKit

class PopUpMaker {
    static func showPopUp(title: String, content: String) {
        let vc = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last?.visibleViewController
        let popUpView = PopUpView(title: title, content: content)
        vc?.view.addSubview(popUpView)
        popUpView.center = vc?.view.center ?? CGPoint(x: 0, y: 0)
    }
}
