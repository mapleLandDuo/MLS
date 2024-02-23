//
//  DictSearchViewModel.swift
//  MLS
//
//  Created by SeoJunYoung on 2/22/24.
//

import Foundation

class DictSearchViewModel {
    // MARK: - Properties
    let manager = UserDefaultsManager()
    lazy var recentSearchKeywords: Observable<[String]> = Observable(manager.fetchRecentSearchKeyWord())
    let searchMenus = ["전체(0)","몬스터(0)","아이템(0)","맵(0)","NPC(0)","퀘스트(0)"]
}
