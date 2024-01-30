//
//  String+.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/30.
//

import Foundation

extension String {
    func toNickName(completion: @escaping (String) -> Void) {
        FirebaseManager.firebaseManager.getNickname(userEmail: self) { nickName in
            if let nickName = nickName {
                completion(nickName)
            }
        }
    }
}
