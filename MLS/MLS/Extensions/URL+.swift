//
//  URL+.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/03/12.
//

import Foundation

extension URL {
    static func getImageUrl(code: String, type: DictType) -> URL? {
        switch type {
        case .item:
            return URL(string: "https://maplestory.io/api/gms/62/item/\(code)/icon?resize=2")
        case .monster:
            return URL(string: "https://maplestory.io/api/gms/62/mob/\(code)/render/move?bgColor=")
        case .map:
            return URL(string: "https://mapledb.kr/Assets/image/minimaps/\(code).png")
        case .npc:
            return URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon?resize=2")
        case .quest:
            return URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon")
        }
    }
    
    static func getDictImageUrl(code: String, type: DictType, completion: @escaping (URL?, DictType) -> Void) {
        var url: URL?
        switch type {
        case .item:
            url = URL(string: "https://maplestory.io/api/gms/62/item/\(code)/icon?resize=2")
            completion(url, type)
        case .monster:
            url = URL(string: "https://maplestory.io/api/gms/62/mob/\(code)/render/move?bgColor=")
            URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data else{ return }
                if data.isEmpty {
                    let secondUrl = URL(string: "https://maplestory.io/api/kms/284/mob/\(code)/icon?resize=2")
                    completion(secondUrl, type)
                } else {
                    completion(url, type)
                }
            }.resume()
        case .map:
            url = URL(string: "https://mapledb.kr/Assets/image/minimaps/\(code).png")
            completion(url, type)
        case .npc:
            url = URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon?resize=2")
            completion(url, type)
        case .quest:
            url = URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon")
            completion(url, type)
        }
    }
}
