//
//  BasicController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

import SnapKit

class BasicController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print(self, "init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print(self, "deinit")
    }
}

// MARK: - LifeCycle
extension BasicController {
    
    override func viewDidLoad() {
        setUpColor()
    }
}

// MARK: - SetUp
private extension BasicController {
    
    func setUpColor() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Methods
extension BasicController {
    func checkAnnouncementData() {
        let manager = UserDefaultsManager()
        let notice = AnnouncementData(
            number: 2,
            title: "공지사항",
            content: "안녕하세요 메랜사 입니다."
        )
        if !manager.fetchIsCheckNotice(number: notice.number) {
            PopUpMaker.showPopUp(title: notice.title, content: notice.content)
            manager.setIsCheckNotice(toggle: true, number: notice.number)
        }
    }
}
