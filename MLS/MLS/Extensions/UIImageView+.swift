//
//  UIImageView+.swift
//  MLS
//
//  Created by SeoJunYoung on 3/13/24.
//

import UIKit

import Kingfisher

extension UIImageView {
    
    func setImageToDictCode(code: String, type: DictType) {
        self.kf.indicatorType = .activity
        var url: URL?
        switch type {
        case .item:
            url = URL(string: "https://maplestory.io/api/gms/62/item/\(code)/icon?resize=2")
        case .monster:
            url = URL(string: "https://maplestory.io/api/gms/62/mob/\(code)/render/move?bgColor=")
            URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data else{ return }
                if data.isEmpty {
                    url = URL(string: "https://maplestory.io/api/kms/284/mob/\(code)/icon?resize=2")
                    DispatchQueue.main.async { [weak self] in
                        self?.kf.setImage(with: url)
                        return
                    }
                    return
                }
            }.resume()
        case .map:
            self.image = UIImage(named: "Map-Image")
            return
        case .npc:
            url = URL(string: "https://maplestory.io/api/gms/62/npc/\(code)/icon?resize=2")
        case .quest:
            self.image = UIImage(named: "quest-Image")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.kf.setImage(with: url)
        }
    }
}
