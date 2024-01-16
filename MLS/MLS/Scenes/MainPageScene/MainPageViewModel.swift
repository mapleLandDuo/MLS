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
    var features: [[FeatureCellData]] = [
        [
            FeatureCellData(title: "도감", discription: "몬스터 도감, 아이템 도감", image: UIImage(systemName: "book.closed"))
        ],
        [
            FeatureCellData(title: "최신글", image: UIImage(systemName: "chevron.forward.2")),
            FeatureCellData(title: "사고팔고", image: UIImage(systemName: "chevron.forward.2")),
            FeatureCellData(title: "Test", image: UIImage(systemName: "chevron.forward.2")),
            FeatureCellData(title: "test2", image: UIImage(systemName: "chevron.forward.2"))
        ]
    ]
    var sideMenuItems: [FeatureCellData] = [
        FeatureCellData(title: "test1", image: UIImage(systemName: "folder")),
        FeatureCellData(title: "test2", image: UIImage(systemName: "folder")),
        FeatureCellData(title: "test3", image: UIImage(systemName: "folder")),
        FeatureCellData(title: "test4", image: UIImage(systemName: "folder")),
        FeatureCellData(title: "test5", image: UIImage(systemName: "folder")),
        FeatureCellData(title: "test6", image: UIImage(systemName: "folder")),
    ]
}
