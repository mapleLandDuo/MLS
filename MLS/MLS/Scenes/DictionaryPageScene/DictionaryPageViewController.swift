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
//        FirebaseManager.firebaseManager.loadLinks { datas in
//            guard let datas = datas else { return }
//            for data in datas {
//
//            }
//        }
        guard let url = URL(string: "https://mapledb.kr/item.php") else { return }
        print("trying:")
            if let doc = try? HTML(url: url, encoding: .utf8) {
                guard let temp = doc.innerHTML else { return }
//                guard let level = temp.components(separatedBy: "<span>LEVEL</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                var nameArray = temp.components(separatedBy: "<span class=\"text-bold fs-3 search-page-add-content-box-main-title mt-2\">").map({$0.components(separatedBy: "</span>").first!})
                var codeArray = temp.components(separatedBy: "src=\"https://maplestory.io/api/gms/62/item/").map({$0.components(separatedBy: "/icon?resize=2").first!})
                codeArray.removeFirst()
                nameArray.removeFirst()
                
                for (i, code) in codeArray.enumerated() {
                    let item = DictionaryItemLink(name: nameArray[i], link: code)
                    FirebaseManager.firebaseManager.saveDictionaryItemLink(item: item) { _ in
                        print(nameArray[i],"update")
                    }
                }
                
//                var array = temp.components(separatedBy: "<span class=\"text-bold fs-3 search-page-add-content-box-main-title mt-2\">")
//                array.removeFirst()
//                print(array)
//                for i in array {
//                    print(i)
//                }
            //<span class="text-bold fs-3 search-page-add-content-box-main-title mt-2">
            }
    }
}
