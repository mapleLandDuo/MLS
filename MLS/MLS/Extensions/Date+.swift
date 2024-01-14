//
//  Date+.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/14.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }
}
