//
//  DictSearchSortedEnum.swift
//  MLS
//
//  Created by SeoJunYoung on 2/28/24.
//

import UIKit

enum DictSearchSortedEnum: String, CaseIterable {
    case defaultSorted = "가나다 순"
    case highestLevel = "레벨 높은 순"
    case lowestLevel = "레벨 낮은 순"
    case highestExp = "획득 경험치 높은 순"
    case lowestExp = "획득 경험치 낮은 순"
}
