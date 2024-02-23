//
//  SceneDelegate.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("[SceneDelegate]:", #function)
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: DictLandingViewController(viewModel: DictLandingViewModel()))
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        let userDefaultManager = UserDefaultsManager()
        if !userDefaultManager.fetchIsAutoLogin() {
            LoginManager.manager.logOut { _ in }
            print("logOut")
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let rootVC = window?.rootViewController else { return }
        let manager = UserDefaultsManager()
        let notice = AnnouncementData(
            number: 0,
            title: "공지사항",
            content: "안녕하세요 메랜사 입니다."
        )
        rootVC.checkPopUpView {
            if !manager.fetchIsCheckNotice(number: notice.number) {
                PopUpMaker.showPopUp(title: notice.title, content: notice.content)
                manager.setIsCheckNotice(toggle: true, number: notice.number)
            }
        }

    }

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
