//
//  MainPageViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import UIKit

struct FeatureCellData {
    var title: String?
    var description: String?
    var image: UIImage?
}

class MainPageViewModel {
    // MARK: - Properties
    
    var features: [[FeatureCellData]] = [
        [
            FeatureCellData(title: "도감", description: "몬스터 도감, 아이템 도감", image: UIImage(systemName: "book.closed"))
        ],
        [
            FeatureCellData(title: "최신글", image: UIImage(systemName: "chevron.forward.2")),
            FeatureCellData(title: "사고팔고", image: UIImage(systemName: "chevron.forward.2"))
        ]
    ]
    
    private var sideMenuItems: [[FeatureCellData]] = [
        [
            FeatureCellData(title: "프로필")
        ],
        [
            FeatureCellData(title: "자유 게시판", image: UIImage(systemName: "list.bullet.rectangle.portrait.fill")),
            FeatureCellData(title: "거래 게시판", image: UIImage(systemName: "list.bullet.rectangle.portrait.fill"))
        ], [
            FeatureCellData(title: "앱정보", image: UIImage(systemName: "info.circle.fill")),
            FeatureCellData(title: "문의하기", image: UIImage(systemName: "questionmark.circle.fill")),
            FeatureCellData(title: "개인정보처리 방침", image: UIImage(systemName: "hand.raised.circle.fill"))
        ]
    ]
}

// MARK: - Methods
extension MainPageViewModel {

    func fetchSideMenuItems() -> [[FeatureCellData]] {
        var temp = sideMenuItems
        if LoginManager.manager.isLogin() {
            temp.append([
                FeatureCellData(title: "로그아웃", image: UIImage(systemName: "lock.open")),
                FeatureCellData(title: "회원 탈퇴", image: UIImage(systemName: "person.fill.xmark"))
            ])
            return temp
        } else {
            return temp
        }
    }

    func fetchMainPost(type: BoardSeparatorType, completion: @escaping ([Post]?) -> Void) {
        switch type {
        case .normal:
            FirebaseManager.firebaseManager.fetchPosts(type: [.normal], itemCount: 3) { posts in
                completion(posts)
            }
        case .buy, .sell, .complete:
            FirebaseManager.firebaseManager.fetchPosts(type: [.buy, .sell, .complete], itemCount: 3) { posts in
                completion(posts)
            }
        }
    }
}
