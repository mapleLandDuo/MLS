//
//  DatabaseUpdateManager.swift
//  MLS
//
//  Created by SeoJunYoung on 1/29/24.
//

import Foundation

import Kanna

struct DictionaryNameLinkUpdateItem: Codable {
    var name: String
    var link: String
}

struct DictionaryLinkUpdateMap: Codable {
    var name: String
    var code: String
}

struct DictionaryLinkUpdateNPC: Codable {
    var name: String
    var code: String
}

struct DictionaryLinkUpdateQuest: Codable {
    var name: String
    var code: String
}

class DatabaseUpdateManager {
    // MARK: - Update Links
    
    func updateItemsLink() {
        guard let url = URL(string: "https://mapledb.kr/item.php") else { return }
        if let doc = try? HTML(url: url, encoding: .utf8) {
            doc.css("div.search-page-add-content").forEach { docs in
                let contents = docs.css("div.search-page-add-content-box-main.mb-3")
                for content in contents {
                    guard let name = content.css("h3").first?.text else { return }
                    guard let code = content.css("img.search-page-add-content-box-main-img").map({ $0["name"] }).first! else { return }
                    let item = DictionaryNameLinkUpdateItem(name: name, link: code)
                    FirebaseManager.firebaseManager.updateDictionaryLink(collection: .dictionaryItemLink, documentName: name, item: item) { error in
                        if error != nil {
                            print(name, "fail")
                        } else {
                            print(name, "update")
                        }
                    }
                }
            }
        }
    }
    
    func updateMonsterLink() {
        guard let url = URL(string: "https://mapledb.kr/mob.php") else { return }
        var updateMonsters: [String] = []
        if let doc = try? HTML(url: url, encoding: .utf8) {
            doc.css("div.search-page-add-content-box-main.mb-3").forEach { docs in
                guard let name = docs.css("h3").first?.text else { return }
                guard let code = docs.css("img.search-page-add-content-box-main-img").map({ $0["name"] }).first! else { return }
                if !updateMonsters.contains(name) {
                    updateMonsters.append(name)
                    let item = DictionaryNameLinkUpdateItem(name: name, link: code)
                    FirebaseManager.firebaseManager.updateDictionaryLink(collection: .dictionaryMonstersLink, documentName: name, item: item) { error in
                        if error != nil {
                            print(name, "fail")
                        } else {
                            print(name, "update")
                        }
                    }
                }

            }
        }
    }
    
    func updateMapLink() {
        guard let url = URL(string: "https://mapledb.kr/map.php") else { return }
        
        if let doc = try? HTML(url: url, encoding: .utf8) {
            guard let temp = doc.innerHTML?.components(separatedBy: "<div class=\"search-page-add-content-box-main\">") else { return }
            for (i, item) in temp.enumerated() {
                if i != 0 {
                    guard let name = item.components(separatedBy: "alt=").last?.components(separatedBy: "name=").first else { return }
                    let mapName = name.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "&lt;", with: " <").replacingOccurrences(of: "&gt;", with: ">").replacingOccurrences(of: " 이미지", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    guard let code = item.components(separatedBy: "name=").last?.components(separatedBy: "src=").first else { return }
                    let mapCode = code.replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let mapItem = DictionaryNameLinkUpdateItem(name: mapName, link: mapCode)
                    
                    FirebaseManager.firebaseManager.updateDictionaryLink(collection: .dictionaryMapLink, documentName: mapName, item: mapItem, completion: { error in
                        if error != nil {
                            print(name, "fail")
                        } else {
                            print(name, "update")
                        }
                    })
                }
            }
        }
    }
    
    func updateNPCLink() {
        guard let url = URL(string: "https://mapledb.kr/npc.php") else { return }
        if let doc = try? HTML(url: url, encoding: .utf8) {
            guard let temp = doc.innerHTML?.components(separatedBy: "<div class=\"search-page-add-content-box-main\">") else { return }
            for (i, item) in temp.enumerated() {
                if i != 0 {
                    guard let name = item.components(separatedBy: "alt=").last?.components(separatedBy: "name=").first else { return }
                    let npcName = name.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "&lt;", with: " <").replacingOccurrences(of: "&gt;", with: ">").replacingOccurrences(of: " 이미지", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if npcName == "스트링 없음" { continue }
                    
                    guard let code = item.components(separatedBy: "name=").last?.components(separatedBy: "src=").first else { return }
                    let npcCode = code.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let npcItem = DictionaryNameLinkUpdateItem(name: npcName, link: npcCode)
                    
                    FirebaseManager.firebaseManager.updateDictionaryLink(collection: .dictionaryNPCLink, documentName: npcName, item: npcItem, completion: { error in
                        if error != nil {
                            print(npcName, "fail")
                        } else {
                            print(npcName, "update")
                        }
                    })
                }
            }
        }
    }
    
    func updateQuestLink() {
        guard let url = URL(string: "https://mapledb.kr/quest.php") else { return }
        var count = 1
        if let doc = try? HTML(url: url, encoding: .utf8) {
            guard let temp = doc.innerHTML?.components(separatedBy: "<div class=\"search-page-add-content-box-main\">") else { return }
            for (i, item) in temp.enumerated() {
                if i != 0 {
                    guard let name = item.components(separatedBy: "alt=").last?.components(separatedBy: "name=").first else { return }
                    var questName = name.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "&lt;", with: " <").replacingOccurrences(of: "&gt;", with: ">").replacingOccurrences(of: " 이미지", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    guard let code = item.components(separatedBy: "name=").last?.components(separatedBy: "src=").first else { return }
                    let questCode = code.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if questName == "드래곤 라이더" {
                        questName = "드래곤 라이더 <\(count)>"
                        count = count + 1
                    }
                    
                    let questItem = DictionaryNameLinkUpdateItem(name: questName, link: questCode)
                    FirebaseManager.firebaseManager.updateDictionaryLink(collection: .dictionaryQuestLink, documentName: questName, item: questItem, completion: { error in
                        if error != nil {
                            print(questName, "fail")
                        } else {
                            print(questName, "update")
                        }
                    })
                }
            }
        }
    }
}

// MARK: - fetch Dictionarys
extension DatabaseUpdateManager {
    func fetchItems(completion: @escaping ([DictItem]) -> Void) {
        FirebaseManager.firebaseManager.fetchLinks(collectionName: .dictionaryItemLink) { datas in
            var result: [DictItem] = []
            guard let datas = datas else { return }
            for data in datas {
                guard let url = URL(string: "https://mapledb.kr/search.php?q=\(data.link)&t=item") else { return }
                var item = DictItem(
                    name: data.name,
                    code: data.link,
                    division: "",
                    mainCategory: "",
                    subCategory: "",
                    defaultValues: [],
                    detailValues: [],
                    dropTable: []
                )
                if let doc = try? HTML(url: url, encoding: .utf8) {
                    var count = 0
                    doc.css("div.search-page-info-content-box").forEach { contents in
                        var keys = contents.css("h4").compactMap { $0.text }
                        let values = contents.css("span").compactMap { $0.text }
                        if keys.count != values.count {
                            keys.insert("설명", at: 1)
                        }
                        let zip = zip(keys, values)
                        for (key, value) in zip {
                            if count == 0 {
                                item.defaultValues.append(DictionaryNameDescription(name: key, description: value))
                            } else {
                                if key == "분류" {
                                    item.division = value
                                } else if key == "주 카테고리" {
                                    item.mainCategory = value
                                } else if key == "부 카테고리" {
                                    item.subCategory = value
                                } else {
                                    if key == "상점 판매가" {
                                        let money = value.replacingOccurrences(of: "메소", with: "").replacingOccurrences(of: ",", with: "")
                                        item.detailValues.append(DictionaryNameDescription(name: key, description: money))
                                    } else {
                                        item.detailValues.append(DictionaryNameDescription(name: key, description: value))
                                    }
                                }
                            }
                            count += 1
                        }
                    }
                    let dropTableNames = doc.css("h4.text-bold.fs-3.search-page-add-content-box-main-title.mt-2").compactMap { $0.text }
                    let dropTableValues = doc.css("span.text-bold-underline").compactMap { $0.text }
                    let dropTables = zip(dropTableNames, dropTableValues)
                    for (name, value) in dropTables {
                        item.dropTable.append(DictionaryNameDescription(name: name, description: value))
                    }
                }
                result.append(item)
                print(item.name, "mapping")
            }
            completion(result)
        }
    }
    
    func fetchMonsters(completion: @escaping ([DictMonster]) -> Void) {
        FirebaseManager.firebaseManager.fetchLinks(collectionName: .dictionaryMonstersLink) { datas in
            var result: [DictMonster] = []
            guard let datas = datas else { return }
            for data in datas {
                guard let url = URL(string: "https://mapledb.kr/search.php?q=\(data.link)&t=mob") else { return }
                var item = DictMonster(code: data.link, name: data.name, defaultValues: [], detailValues: [], hauntArea: [], dropTable: [])
                if let doc = try? HTML(url: url, encoding: .utf8) {
                    var count = 0
                    doc.css("div.search-page-info-content-box").forEach { doc2 in
                        if count == 0 {
                            let key = doc2.css("h4").compactMap { $0.text }
                            let value = doc2.css("span").compactMap { $0.text }
                            let zip = zip(key, value)
                            for (key, value) in zip {
                                let defaultValue = value.replacingOccurrences(of: ",", with: "")
                                item.defaultValues.append(DictionaryNameDescription(name: key, description: defaultValue))
                            }
                            doc2.css("div.search-page-info-content-spawnmap").forEach { doc3 in
                                let maps = doc3.css("span").compactMap { $0.text }
                                item.hauntArea = maps
                            }
                        } else if count == 1 {
                            var key = doc2.css("h4").compactMap { $0.text }
                            let value = doc2.css("span").compactMap { $0.text }
                            key.insert("레벨별 필요 명중률", at: 3)
                            if key.count != value.count {
                                key.insert("특성", at: 0)
                            }
                            let zip = zip(key, value)
                            for (key, value) in zip {
                                item.detailValues.append(DictionaryNameDescription(name: key, description: value))
                            }
                        }
                        count += 1
                    }
                    doc.css("div.search-page-add-content").forEach { doc2 in
                        var key = doc2.css("h4.text-bold.fs-3.search-page-add-content-box-main-title.mt-2").compactMap { $0.text }
                        var value = doc2.css("span.text-bold-underline").compactMap { $0.text }
                        guard let money = doc2.css("span.favorite-item-info-text.fs-4.text-bold").first?.css("div").first?.text else { return }
                        key.insert(money, at: 0)
                        var zip = zip(key, value)
                        for (key, value) in zip {
                            item.dropTable.append(DictionaryNameDescription(name: key, description: value))
                        }
                    }
                }
                result.append(item)
                print(item.name, "mapping")
            }
            completion(result)
        }
    }
    
    func fetchMap(completion: @escaping ([DictMap]) -> Void) {
        FirebaseManager.firebaseManager.fetchLinks(collectionName: .dictionaryMapLink) { maps in
            var result: [DictMap] = []
            guard let maps = maps else { return }
            for map in maps {
                guard let url = URL(string: "https://mapledb.kr/search.php?q=\(map.link)&t=map") else { return }
                var mapItem = DictMap(code: map.link, name: map.name, monsters: [], npcs: [])
                if let doc = try? HTML(url: url, encoding: .utf8) {
                    doc.css("div.search-page-add-content").forEach { item in
                        
                        let types = item.css("img.search-page-add-content-box-main-img").map { $0["img_type"] }
                        let titles = item.css("h4.text-bold.fs-3.search-page-add-content-box-main-title.mt-2").map { $0.text }
                        let descriptions = item.css("span.text-bold-underline").map { $0.text }
                        
                        for i in 0 ... types.count - 1 {
                            switch types[i] {
                            case "mob":
                                guard let title = titles[i],
                                      let description = descriptions[i] else { return }
                                mapItem.monsters.append(DictionaryNameDescription(name: title, description: description))
                            case "npc":
                                guard let npcName = titles[i] else { return }
                                mapItem.npcs.append(npcName)
                            default:
                                continue
                            }
                        }
                    }
                }
                result.append(mapItem)
                print(mapItem.name, "mapping")
            }
            completion(result)
        }
    }
    
    func fetchNPC(completion: @escaping ([DictNPC]) -> Void) {
        FirebaseManager.firebaseManager.fetchLinks(collectionName: .dictionaryNPCLink) { npcs in
            var result: [DictNPC] = []
            guard let npcs = npcs else { return }
            for npc in npcs {
                guard let url = URL(string: "https://mapledb.kr/search.php?q=\(npc.link)&t=npc") else { return }
                var npcItem = DictNPC(code: npc.link, name: npc.name, maps: [], quests: [])
                if let doc = try? HTML(url: url, encoding: .utf8) {
                    var count = 0
                    doc.css("div.search-page-add-content.mb-3").forEach { doc2 in
                        let value = doc2.css("h4").compactMap { $0.text }.filter { $0 != "" }
                        if count == 0 {
                            npcItem.maps = value
                        } else if count == 1 {
                            npcItem.quests = value
                        }
                        count += 1
                    }
                    result.append(npcItem)
                    print(npcItem.name, "mapping")
                }
            }
            completion(result)
        }
    }

    func fetchQuest(completion: @escaping ([DictQuest]) -> Void) {
        FirebaseManager.firebaseManager.fetchLinks(collectionName: .dictionaryQuestLink) { quests in
            guard let quests = quests else { return }
            var result: [DictQuest] = []
            for quest in quests {
                guard let url = URL(string: "https://mapledb.kr/search.php?q=\(quest.link)&t=quest") else { return }
                var questItem = DictQuest(code: quest.link, name: quest.name, currentQuest: quest.name, times: "", defaultValues: [], rollToStart: [], toCompletion: [], reward: [])
                if let doc = try? HTML(url: url, encoding: .utf8) {
                    let titles = doc.css("h3.search-page-add-content-title.text-bold.fs-7.mt-3.mb-1")
                    let contents = doc.css("div.search-page-add-content.mb-3")
                    let items = zip(titles, contents)
                    for (title, content) in items {
                        switch title.text {
                        case "퀘스트 순서":
                            let quests = content.css("div.search-page-add-content-box, a.search-page-add-content-box").map { $0.css("span.text-bold.fs-2.search-page-add-content-box-main-title.mt-2, h4.text-bold.fs-2.search-page-add-content-box-main-title.mt-2").first?.text }
                            guard let currentQuest = quests[1] else { return }
                            questItem.preQuest = quests[0]
                            questItem.currentQuest = currentQuest
                            questItem.laterQuest = quests[2]
                            
                        case "정보":
                            let contents = content.css("div.search-page-info-content-box-detail.text-bold").map { $0.css("span").first?.text }
                            guard let times = contents[0],
                                  let minLevel = contents[1],
                                  let maxLevel = contents[2],
                                  let money = contents[3] else { return }
                            questItem.times = times
                            questItem.defaultValues.append(DictionaryNameDescription(name: "시작 최소 레벨", description: minLevel))
                            questItem.defaultValues.append(DictionaryNameDescription(name: "시작 최대 레벨", description: maxLevel))
                            questItem.defaultValues.append(DictionaryNameDescription(name: "시작 최소 메소", description: money))
                            
                            let npcs = content.css("a.search-page-info-content-box-default.text-bold").map { $0.css("span").first?.text }
                            guard let startNPC = npcs[0],
                                  let endNPC = npcs[1] else { return }
                            questItem.defaultValues.append(DictionaryNameDescription(name: "시작 NPC", description: startNPC))
                            questItem.defaultValues.append(DictionaryNameDescription(name: "종료 NPC", description: endNPC))
                            
                            content.css("div.search-page-info-content-box-detail.text-bold").forEach { item in
                                item.css("h4").forEach { job in
                                    if job.text == "시작 가능 직업" {
                                        questItem.rollToStart = item.css("span").map { $0.text ?? "" }
                                    }
                                }
                            }
                        case "완료 조건":
                            let titles = content.css("h4.text-bold.fs-2.search-page-add-content-box-main-title.mt-2").map { $0.text }
                            let descriptions = content.css("span.favorite-item-info-text.fs-4.text-bold.text-bold-underline").map { $0.css("div").first?.text }
                            
                            for i in 0 ..< titles.count {
                                guard let title = titles[i],
                                      let description = descriptions[i] else { return }
                                questItem.toCompletion.append(DictionaryNameDescription(name: title, description: description))
                            }
                        case "보상":
                            content.css("div.search-page-add-content-box").forEach { item in
                                let titles = item.css("h4").map { $0.text }
                                let descriptions = item.css("span").map { $0.text }
                                
                                for i in 0 ..< titles.count {
                                    guard let title = titles[i],
                                          let description = descriptions[i] else { return }
                                    let value = description.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: ",", with: "")
                                    questItem.reward.append(DictionaryNameDescription(name: title, description: value))
                                }
                            }
                            content.css("a.search-page-add-content-box").forEach { item in
                                if item.text == nil { return }
                                let titles = item.css("h4.text-bold.fs-2.search-page-add-content-box-main-title.mt-2").map { $0.text }
                                let descriptions = item.css("span.favorite-item-info-text.fs-4.text-bold.text-bold-underline").map { $0.css("div").first?.text }
                                
                                for i in 0 ..< titles.count {
                                    guard let title = titles[i],
                                          let description = descriptions[i] else { return }
                                    questItem.reward.append(DictionaryNameDescription(name: title, description: description))
                                }
                            }
                        default:
                            break
                        }
                    }
                }
                result.append(questItem)
                print(questItem.name, "mapping")
            }
            completion(result)
        }
    }
}

// MARK: DB to JSON
extension DatabaseUpdateManager {
    
    func readyToJson<T: Sqlable>(type: T.Type, completion: @escaping () -> Void) {
        FirebaseManager.firebaseManager.fetchDatas(colName: T.tableName.rawValue) { (items: [T]?) in
            guard let items = items else { return }
            self.changeToJson(items: items, fileName: T.tableName) {
                completion()
            }
        }
    }
    
    func readyToJson(fileName: Filename, completion: @escaping () -> Void) {
        switch fileName {
        case .items:
            FirebaseManager.firebaseManager.fetchDatas(colName: Filename.items.rawValue) { (items: [DictItem]?) in
                guard let items = items else { return }
                self.changeToJson(items: items, fileName: Filename.items) {
                    completion()
                }
                
            }
        case .monsters:
            FirebaseManager.firebaseManager.fetchDatas(colName: Filename.monsters.rawValue) { (items: [DictMonster]?) in
                guard let items = items else { return }
                self.changeToJson(items: items, fileName: Filename.monsters) {
                    completion()
                }
            }
        case .maps:
            FirebaseManager.firebaseManager.fetchDatas(colName: Filename.maps.rawValue) { (items: [DictMap]?) in
                guard let items = items else { return }
                self.changeToJson(items: items, fileName: Filename.maps) {
                    completion()
                }
            }
        case .npcs:
            FirebaseManager.firebaseManager.fetchDatas(colName: Filename.npcs.rawValue) { (items: [DictNPC]?) in
                guard let items = items else { return }
                self.changeToJson(items: items, fileName: Filename.npcs) {
                    completion()
                }
            }
        case .quests:
            FirebaseManager.firebaseManager.fetchDatas(colName: Filename.quests.rawValue) { (items: [DictQuest]?) in
                guard let items = items else { return }
                self.changeToJson(items: items, fileName: Filename.quests) {
                    completion()
                }
            }
        }
    }
    
    func changeToJson<T: Codable>(items: [T], fileName: Filename, completion: @escaping () -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(items)
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first
            {
                let pathWithFileName = documentDirectory.appendingPathComponent("\(fileName.rawValue).json")
                try jsonData.write(to: pathWithFileName)
                print("Encoding")
                completion()
            }
        } catch {
            print("Error encoding or writing JSON: \(error)")
            completion()
        }
    }
    
    func fetchJson<T: Sqlable>(type: T.Type) {
        let db = SqliteManager()
        if let url = Bundle.main.url(forResource: T.tableName.rawValue, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([T].self, from: data)
                db.deleteTable(tableName: T.tableName.tableName)
                db.createTable(tableName: T.tableName.tableName, columnNames: T.columnOrder)
                db.saveData(data: jsonData) {
                    db.fetchData() { (items: [T]) in
                        print("fetch \(T.tableName.rawValue)", items)
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        } else {
            print("파일없음")
        }
    }
    
    func searchDirectory(fileName: Filename) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("\(fileName.rawValue).json")
            print(pathWithFileName)
        }
    }
}

enum Filename: String {
    case monsters
    case items
    case maps
    case npcs
    case quests
}

extension Filename {
    var tableName: String {
        switch self {
        case .monsters:
            return "dictMonsterTable"
        case .items:
            return "dictItemTable"
        case .maps:
            return "dictMapTable"
        case .npcs:
            return "dictNpcTable"
        case .quests:
            return "dictQuestTable"
        }
    }
}
