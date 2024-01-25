//
//  DictionaryPageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/25/24.
//

import Foundation
import Kanna

struct DictionaryItemLink: Codable {
    var name: String
    var link: String
}
class DictionaryPageViewController: BasicController {
    
    
}

extension DictionaryPageViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://mapledb.kr/mob.php") else { return }
        
            if let doc = try? HTML(url: url, encoding: .utf8) {
                guard let temp = doc.innerHTML?.components(separatedBy: "<div class=\"search-page-add-content-box-main mb-3\">") else { return }
                for (i, str) in temp.enumerated() {
                    if i != 0 {
                        guard let code = str.components(separatedBy: "name=")[1].components(separatedBy: "src=").first else { return }
                        guard let name = str.components(separatedBy: "<span class=\"text-bold fs-3 search-page-add-content-box-main-title mt-2\">")[1].components(separatedBy: "</span>").first else { return }
                        let itemName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        let itemCode = code.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: " ", with: "")
                        let itemLink = "https://mapledb.kr/search.php?q=\(itemCode)&t=mob"
                        let firebaseManager = FirebaseManager()
                        let item = DictionaryItemLink(name: itemName, link: itemLink)
                        firebaseManager.saveDictionaryItemLink(item: item) { _ in
                            print(i,":성공")
                        }
                    }
                }
            }
    }

}
// item Separator = <div class="search-page-add-content-box-main mb-3">
// name Separator = <span class="text-bold fs-3 search-page-add-content-box-main-title mt-2">
//https://mapledb.kr/search.php?q=8510000&t=mob
