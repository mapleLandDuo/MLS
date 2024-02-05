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
}

// MARK: - Methods

extension UserDefaultsManager {
    
    func setAutoLogin(toggle: Bool) {
        defaults.set(toggle, forKey: isAutoLogin)
    }

    func getIsAutoLogin() -> Bool {
        return defaults.bool(forKey: isAutoLogin)
    }
}
