//
//  Utils.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/27.
//

import UIKit

import FirebaseAuth

class Utils {
    static let utils = Utils()
    static var currentUser = Auth.auth().currentUser?.email

    private init() {}

    func getNavigationHeight(vc: UIViewController) -> CGFloat {
        guard let navigationController = vc.navigationController else {
            return 0
        }

        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        let navigationHeight = navigationBarHeight + statusBarHeight
        return navigationHeight
    }
}
