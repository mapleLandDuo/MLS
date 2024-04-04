//
//  DictSectionDatas.swift
//  MLS
//
//  Created by SeoJunYoung on 2/28/24.
//

import UIKit

struct DictSectionDatas {
    let iconImage: UIImage?
    let description: String
    var datas: [DictSectionData]
}

struct DictSectionData {
    let image: String
    let title: String
    let level: String
    let type: DictType
}
