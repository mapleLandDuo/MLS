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
//                print(data.name, data.link)
//            }
//        }
        guard let url = URL(string: "https://mapledb.kr/search.php?q=1210100&t=mob") else { return }
        
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
                guard let money = temp.components(separatedBy: "<span class=\"favorite-item-info-text fs-4 text-bold\" style=\"justify-content: center !important;\">")[1].components(separatedBy: "메소 드랍</div>").first?.replacingOccurrences(of: "<div>", with: "").trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                var dropTable = temp.components(separatedBy: "<div><span class=\"text-bold-underline\">").map({$0.components(separatedBy: "%</span>").first!}).compactMap({Double($0)})
                
                var hauntArea = temp.components(separatedBy: "<div class=\"search-page-info-content-spawnmap\">")[1].components(separatedBy: "<h4 class=\"search-page-info-content-box-title text-bold fs-7 mt-0 mb-1 ml-1\">세부</h4>")[0].components(separatedBy: "<span>").map({$0.components(separatedBy: "</span>")[0]})
                hauntArea.removeFirst()
                dropTableName.removeFirst()
                
                let drop = [Double(money)!] + dropTable
                

                print(temp)
                print("===================================================")
                print(level)
                print(exp)
                print(hp)
                print(mp)
                print(hauntArea)
                print(physicalDefense)
                print(magicDefense)
                print(requiredAccuracy)
                print(levelAccuracy)
                print(evasionRate)
                print(drop)
                var monsterDropTable: [DictionaryMonsterDropTable] = []
                for (i, value) in drop.enumerated() {
                    monsterDropTable.append(DictionaryMonsterDropTable(name: dropTableName[i], discription: value))
                }

                let data = DictionaryMonster(
                    code: "temp",
                    name: "temp",
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
            }
    }

}

struct DictionaryMonster: Codable {
    // ID
    let code: String
    //이름
    let name: String
    //레벨
    let level: Int
    //경험치
    let exp: Int
    //체력
    let hp: Int
    //마나
    let mp: Int
    //출몰지역
    let hauntArea: [String]
    //물리 방어력
    let physicalDefense: Int
    //마법 방어력
    let magicDefense: Int
    //필요 명중률
    let requiredAccuracy: Int
    //레벨별 명중률
    let levelAccuracy: String
    //회피율
    let evasionRate: Int
    //드랍 테이블
    let dropTable: [DictionaryMonsterDropTable]
}

struct DictionaryMonsterDropTable: Codable {
    let name: String
    let discription: Double
}


//<span class="text-bold fs-3 search-page-add-content-box-main-title mt-2"> name separator

