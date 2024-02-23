//
//  UserDefaultsManager.swift
//  MLS
//
//  Created by SeoJunYoung on 1/23/24.
//

import Foundation

struct UserDefaultsManager {
    // MARK: - Properties
    
    private let defaults = UserDefaults.standard
    
    private let isAutoLogin = "isAutoLogin"
    private let recentSearchKeyWords = "RecentSearchKeyWords"
}

// MARK: - Methods

extension UserDefaultsManager {
    
    func setAutoLogin(toggle: Bool) {
        defaults.set(toggle, forKey: isAutoLogin)
    }

    func fetchIsAutoLogin() -> Bool {
        return defaults.bool(forKey: isAutoLogin)
    }
    
    func setIsCheckNotice(toggle: Bool, number: Int) {
        defaults.set(toggle, forKey: "isCheckNoticeNumber:\(number)")
    }

    func fetchIsCheckNotice(number: Int) -> Bool {
        return defaults.bool(forKey: "isCheckNoticeNumber:\(number)")
    }
    
    func setRecentSearchKeyWord(keyWords: [String]) {
        defaults.set(keyWords, forKey: recentSearchKeyWords)
    }

    func fetchRecentSearchKeyWord() -> [String] {
        return defaults.array(forKey: recentSearchKeyWords) as? [String] ?? []
    }
}
