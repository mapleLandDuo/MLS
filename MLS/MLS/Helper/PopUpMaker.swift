//
//  PopUpMaker.swift
//  MLS
//
//  Created by SeoJunYoung on 2/21/24.
//

import UIKit

class PopUpMaker {
    static func showPopUp(title: String, content: String) {
        guard let vc = UIApplication.shared.keyWindow?.visibleViewController else { return }
        let popUpView = PopUpView(title: title, content: content)
        vc.view.addSubview(popUpView)
        popUpView.center = vc.view.center
    }
}
