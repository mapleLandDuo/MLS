//
//  MainPageViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import Foundation
import UIKit

struct FeatureCellData {
    var title: String?
    var discription: String?
    var image: UIImage?
}

class MainPageViewModel {
    let loginManager = LoginManager()
    var features: [[FeatureCellData]] = [
        [
            FeatureCellData(title: "도감", discription: "몬스터 도감, 아이템 도감", image: UIImage(systemName: "book.closed"))
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
            FeatureCellData(title: "자유 게시판", image: UIImage(systemName: "list.clipboard")),
            FeatureCellData(title: "거래 게시판", image: UIImage(systemName: "list.clipboard"))
        ],
    ]

}
extension MainPageViewModel {
    // MARK: - Method
    func getSideMenuItems() -> [[FeatureCellData]] {
        var temp = sideMenuItems
        if loginManager.isLogin() {
            temp.append([
                FeatureCellData(title: "로그아웃", image: UIImage(systemName: "lock.open")),
                FeatureCellData(title: "회원탈퇴", image: UIImage(systemName: "person.fill.xmark"))
            ])
            return temp
        } else {
            return temp
        }
    }

}
