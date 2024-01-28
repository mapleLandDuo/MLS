//
//  DictionaryPageViewController.swift
//  MLS
//
//  Created by SeoJunYoung on 1/25/24.
//

import Foundation
import Kanna


class DictionaryPageViewController: BasicController {
    
    
}

extension DictionaryPageViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.firebaseManager.loadLinks { datas in
            guard let datas = datas else { return }
            print(datas.count)
            for dataLinks in datas {
                print("trying",dataLinks.name)
                guard let url = URL(string: "https://mapledb.kr/search.php?q=\(dataLinks.link)&t=item") else { return }
                if let doc = try? HTML(url: url, encoding: .utf8) {
                    var item = DictionaryItem(
                        name: "temp",
                        code: "temp",
                        level: "temp",
                        str: "temp",
                        dex: "temp",
                        int: "temp",
                        luk: "temp",
                        discription: "temp",
                        division: "temp",
                        mainCategory: "temp",
                        subCategory: "temp",
                        detailDiscription: [:],
                        dropTable: []
                    )
                    item.name = dataLinks.name
                    item.code = dataLinks.link
                    guard let temp = doc.innerHTML else { return }
                    for product in doc.xpath("//div[@class='main-content']") {
                        for (i, value) in product.xpath("//div[@class='search-page-info-content-box']").enumerated() {
                            guard var datas = value.text?.components(separatedBy: "\r\n").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).filter({$0 != ""}) else { return }
                            if i == 0 {
                                if datas.contains("LEVEL") {
                                    guard let index = datas.firstIndex(of: "LEVEL") else { return }
                                    item.level = datas[index + 1]
                                    datas.remove(at: index)
                                    datas.remove(at: index)
                                }
                                if datas.contains("분류") {
                                    guard let index = datas.firstIndex(of: "분류") else { return }
                                    item.division = datas[index + 1]
                                    datas.remove(at: index)
                                    datas.remove(at: index)
                                }
                                if datas.contains("주 카테고리") {
                                    guard let index = datas.firstIndex(of: "주 카테고리") else { return }
                                    item.mainCategory = datas[index + 1]
                                    datas.remove(at: index)
                                    datas.remove(at: index)
                                }
                                if datas.contains("부 카테고리") {
                                    guard let index = datas.firstIndex(of: "부 카테고리") else { return }
                                    item.subCategory = datas[index + 1]
                                    datas.remove(at: index)
                                    datas.remove(at: index)
                                }
                                if datas.contains("STR") {
                                    guard let index = datas.firstIndex(of: "STR") else { return }
                                    item.str = datas[index + 1]
                                    datas.remove(at: index)
                                    datas.remove(at: index)
                                } else { item.str = nil }
                                if datas.contains("DEX") {
                                    guard let index = datas.firstIndex(of: "DEX") else { return }
                                    item.dex = datas[index + 1]
                                    datas.remove(at: index)
                                    datas.remove(at: index)
                                } else { item.dex = nil }
                                if datas.contains("INT") {
                                    guard let index = datas.firstIndex(of: "INT") else { return }
                                    item.int = datas[index + 1]
                                    datas.remove(at: index)
                                    datas.remove(at: index)
                                } else { item.int = nil }
                                if datas.contains("LUK") {
                                    guard let index = datas.firstIndex(of: "LUK") else { return }
                                    item.luk = datas[index + 1]
                                    datas.remove(at: index)
                                    datas.remove(at: index)
                                } else { item.luk = nil }
                                if datas.count == 1 {
                                    item.discription = datas.first!
                                } else { item.discription = nil }
                            } else {
                                var temp: String = ""
                                for (i, data) in datas.enumerated() {
                                    if i % 2 == 0 {
                                        temp = data
                                    } else {
                                        item.detailDiscription.updateValue(data, forKey: temp)
                                    }
                                }
                            }
                        }
                        for value in product.xpath("//div[@class='search-page-add-content']") {
                            guard var datas = value.text?.components(separatedBy: "\r\n").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).filter({$0 != ""}) else { return }
                            var count = 0
                            var dropItem = DictionaryItemDropTable(name: "temp", discription: "temp")
                            for data in datas {
                                if count == 0 {
                                    dropItem.name = data
                                    count += 1
                                } else if count == 8 {
                                    dropItem.discription = data
                                    count += 1
                                } else if count == 9 {
                                    count = 0
                                    if dropItem.name != "temp" {
                                        item.dropTable.append(dropItem)
                                    }
                                } else {
                                    count += 1
                                }
                            }
                        }
                    }
                    FirebaseManager.firebaseManager.saveDictionaryItem(item: item) { error in
                        if error != nil {
                            print(item.name,"upDate")
                        } else {
                            print(item.name,"fail")
                        }
                    }
                }
            }
        }

        

    }
}


