//
//  Utils.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/27.
//

import UIKit

import FirebaseAuth


// Login Manager 
class Utils {
    static let utils = Utils()
    static var currentUser = Auth.auth().currentUser?.email

    private init() {}
}
