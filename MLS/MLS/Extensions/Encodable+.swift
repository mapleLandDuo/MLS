//
//  Encodable+.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/19.
//

import Foundation

//extension Encodable {
//    var dictionary: [String: Any] {
//        guard let data = try? JSONEncoder().encode(self) else { return [:] }
//        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] } ?? [:]
//    }
//    
//    var columnNames: String {
//        return dictionary.keys.joined(separator: ", ")
//    }
//}
