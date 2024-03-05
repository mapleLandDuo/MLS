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
        if checkUpdateAvailable() {
            presentUpdateAlertVC(rootVC: rootVC)
        }
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
    
    private func checkUpdateAvailable() -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=" + bundleID),
              let data = try? Data(contentsOf: url),
              let jsonData = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
              let results = jsonData["results"] as? [[String: Any]],
              results.count > 0,
              let appStoreVersion = results[0]["version"] as? String else { return false }
        
        let currentVersionArray = currentVersion.split(separator: ".").map { $0 }
        let appStoreVersionArray = appStoreVersion.split(separator: ".").map { $0 }
        
        if currentVersionArray[0] < appStoreVersionArray[0] {
            return true
        } else {
            return currentVersionArray[1] < appStoreVersionArray[1] ? true : false
        }
    }
    
    private func presentUpdateAlertVC(rootVC: UIViewController) {
        let alertVC = UIAlertController(title: "업데이트", message: "업데이트가 필요합니다.", preferredStyle: .alert)
        let alertAtion = UIAlertAction(title: "업데이트", style: .default) { _ in
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/6477212894") else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        alertVC.addAction(alertAtion)
        rootVC.present(alertVC, animated: true)
    }
}
