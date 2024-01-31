//
//  DatabaseUpdateManager.swift
//  MLS
//
//  Created by SeoJunYoung on 1/29/24.
//

import Foundation
import Kanna

class DatabaseUpdateManager {
    func updateItemLink() {
        
    }
    func updateMonsterLink() {
        guard let url = URL(string: "https://mapledb.kr/mob.php") else { return }
        
        if let doc = try? HTML(url: url, encoding: .utf8) {
            guard let temp = doc.innerHTML?.components(separatedBy: "<div class=\"search-page-add-content-box-main mb-3\">") else { return }
            for (i, str) in temp.enumerated() {
                if i != 0 {
                    guard let code = str.components(separatedBy: "name=")[1].components(separatedBy: "src=").first else { return }
                    guard let name = str.components(separatedBy: "<span class=\"text-bold fs-3 search-page-add-content-box-main-title mt-2\">")[1].components(separatedBy: "</span>").first else { return }
                    let itemName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    let itemCode = code.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: " ", with: "")
                    let itemLink = itemCode
                    let item = DictionaryNameLinkUpdateItem(name: itemName, link: itemLink)
                    FirebaseManager.firebaseManager.updateDictionaryMonsterLink(item: item) { _ in
                        print(i,":성공")
                    }
                }
            }
        }
    }
    func updateItem() {
        FirebaseManager.firebaseManager.loadItemLinks { datas in
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
                        description: "temp",
                        division: "temp",
                        mainCategory: "temp",
                        subCategory: "temp",
                        detailDescription: [:],
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
                                    item.description = datas.first!
                                } else { item.description = nil }
                            } else {
                                var temp: String = ""
                                for (i, data) in datas.enumerated() {
                                    if i % 2 == 0 {
                                        temp = data
                                    } else {
                                        item.detailDescription.updateValue(data, forKey: temp)
                                    }
                                }
                            }
                        }
                        for value in product.xpath("//div[@class='search-page-add-content']") {
                            guard var datas = value.text?.components(separatedBy: "\r\n").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).filter({$0 != ""}) else { return }
                            var count = 0
                            var dropItem = DictionaryNameDescription(name: "temp", description: "temp")
                            for data in datas {
                                if count == 0 {
                                    dropItem.name = data
                                    count += 1
                                } else if count == 8 {
                                    dropItem.description = data
                                    if data != "미확인" {
                                        count += 1
                                    } else {
                                        count = 0
                                        item.dropTable.append(dropItem)
                                    }
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
                            print(item.name,"fail")
                        } else {
                            print(item.name,"upDate")
                        }
                    }
                }
            }
        }
    }
    func updateMonsters() {
        FirebaseManager.firebaseManager.loadMonsterLinks { datas in
                   guard let datas = datas else { return }
                   for data in datas {
                       guard let url = URL(string: "https://mapledb.kr/search.php?q=\(data.link)&t=mob") else { return }
                       print("trying:",data.name)
                           if let doc = try? HTML(url: url, encoding: .utf8) {
                               guard let temp = doc.innerHTML else { return }
                               guard let level = temp.components(separatedBy: "<span>LEVEL</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               guard let exp = temp.components(separatedBy: "<span>EXP</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               guard let hp = temp.components(separatedBy: "<span>HP</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               guard let mp = temp.components(separatedBy: "<span>MP</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               guard let physicalDefense = temp.components(separatedBy: "<span>물리 방어력</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               guard let magicDefense = temp.components(separatedBy: "<span>마법 방어력</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               guard let requiredAccuracy = temp.components(separatedBy: "<span>필요 명중률</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               guard let levelAccuracy = temp.components(separatedBy: "<span class=\"fs-2\">")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "</span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               guard let evasionRate = temp.components(separatedBy: "<span>회피율</span>")[1].components(separatedBy: "</span>").first?.replacingOccurrences(of: "<span>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                               var dropTableName = temp.components(separatedBy: "<span class=\"text-bold fs-3 search-page-add-content-box-main-title mt-2\">").map({$0.components(separatedBy: "</span>")[0]})
                               let tempMoney = temp.components(separatedBy: "<span class=\"favorite-item-info-text fs-4 text-bold\" style=\"justify-content: center !important;\">")


                               var dropTable = temp.components(separatedBy: "<div><span class=\"text-bold-underline\">").map({$0.components(separatedBy: "</span>").first!})

                               var hauntArea = temp.components(separatedBy: "<div class=\"search-page-info-content-spawnmap\">")[1].components(separatedBy: "<h4 class=\"search-page-info-content-box-title text-bold fs-7 mt-0 mb-1 ml-1\">세부</h4>")[0].components(separatedBy: "<span>").map({$0.components(separatedBy: "</span>")[0]})
                               hauntArea.removeFirst()
                               dropTableName.removeFirst()
                               dropTable.removeFirst()
                               if dropTable.count > 0 {
                                   dropTable.removeFirst()
                               }
 
                               var monsterDropTable: [DictionaryNameDescription] = []
                               if tempMoney.count > 1 {
                                   guard let money = temp.components(separatedBy: "<span class=\"favorite-item-info-text fs-4 text-bold\" style=\"justify-content: center !important;\">")[1].components(separatedBy: "메소 드랍</div>").first?.replacingOccurrences(of: "<div>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                                   let drop = [money + " 메소"] + dropTable
                                   for (i, value) in drop.enumerated() {
                                       monsterDropTable.append(DictionaryNameDescription(name: dropTableName[i], description: value))
                                   }
                               } else {
                                   let drop = dropTable
                                   for (i, value) in drop.enumerated() {
                                       monsterDropTable.append(DictionaryNameDescription(name: dropTableName[i], description: value))
                                   }
                               }
  
                               let data = DictionaryMonster(
                                    code: data.link,
                                   name: data.name,
                                   level: Int(level.replacingOccurrences(of: ",", with: ""))!,
                                   exp: Int(exp.replacingOccurrences(of: ",", with: ""))!,
                                   hp: Int(hp.replacingOccurrences(of: ",", with: ""))!,
                                   mp: Int(mp.replacingOccurrences(of: ",", with: ""))!,
                                   hauntArea: hauntArea,
                                   physicalDefense: Int(physicalDefense.replacingOccurrences(of: ",", with: ""))!,
                                   magicDefense: Int(magicDefense.replacingOccurrences(of: ",", with: ""))!,
                                   requiredAccuracy: Int(requiredAccuracy.replacingOccurrences(of: ",", with: ""))!,
                                   levelAccuracy: levelAccuracy,
                                   evasionRate: Int(evasionRate.replacingOccurrences(of: ",", with: ""))!,
                                   dropTable: monsterDropTable
                               )
                               FirebaseManager.firebaseManager.saveDictionaryMonster(item: data) { error in
                                   print("upDate:",data.name)
                               }
                           }
                   }
               }

    }
}
