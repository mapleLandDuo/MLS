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
            number: 0,
            title: "공지사항",
            content: """
            <메랜사 새단장>
            
            1. 메랜사의 전체적인 디자인에 큰 변화가 있습니다.
            
            2. 도감에 다양한 기능이 추가 되었습니다. ( + 맵 / NPC / 퀘스트)
            
            3. 회원정보에 직업과 레벨을 입력하면 추후에 레벨에 맞는 데이터를 추천해드릴 예정이에요! (기존의 회원분들은 마이페이지에서 직업 / 레벨을 수정해주세요~)
            
            4. 커뮤니티 페이지는 리모델링에 들어가서 임시 휴무에 들어갔습니다 ㅠ_ㅠ 조금만 기다려 주세요!
            """
        )
        if !manager.fetchIsCheckNotice(number: notice.number) {
            PopUpMaker.showPopUp(title: notice.title, content: notice.content)
            manager.setIsCheckNotice(toggle: true, number: notice.number)
        }
    }
}
