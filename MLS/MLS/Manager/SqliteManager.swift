//
//  SqliteManager.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/18.
//

import Foundation

import SQLite3

protocol Nameable {
    var name: String { get }
}

class SqliteManager {
    var db: OpaquePointer?
    var path = "mlsDatabase.db"

    init() {
        self.db = self.createDB()
    }

    // MARK: Database
    func createDB() -> OpaquePointer? {
        var db: OpaquePointer?
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.path)
            if sqlite3_open(filePath.path, &db) == SQLITE_OK {
                print("Success create db Path")
                return db
            }
        } catch {
            print("error in createDB")
        }
        print("error in createDB - sqlite3_open")
        return nil
    }

    // MARK: Table
//    func createTable(tableName: String) {
//        let query = "CREATE TABLE IF NOT EXISTS \(tableName) (id TEXT PRIMARY KEY, itemData TEXT)"
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
//            if sqlite3_step(statement) == SQLITE_DONE {
//                print("create table success")
//            } else {
//                print("create table step fail")
//            }
//        } else {
//            print("error: create table sqlite3 prepare fail")
//        }
//        sqlite3_finalize(statement)
//    }

    func createTable(tableName: String, columnNames: [String]) {
        let columns = columnNames.joined(separator: ", ")
        let query = "CREATE TABLE IF NOT EXISTS \(tableName) (\(columns))"

        var statement: OpaquePointer?

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("create table success")
            } else {
                print("create table step fail")
            }
        } else {
            print("error: create table sqlite3 prepare fail")
        }
        sqlite3_finalize(statement)
    }

    func deleteTable(tableName: String) {
        let query = "DROP TABLE \(tableName)"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete table success")
            } else {
                print("delete table step fail")
            }
        } else {
            print("delete table prepare fail")
        }
    }

    func fetchTables() {
        var stmt: OpaquePointer?
        let query = "SELECT name FROM sqlite_master WHERE type='table' AND name != 'sqlite_sequence';"

        if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let name = String(cString: sqlite3_column_text(stmt, 0))
                print("name", name)
                var stmt2: OpaquePointer?
                let query2 = "SELECT * FROM \(name);"

                if sqlite3_prepare_v2(self.db, query2, -1, &stmt2, nil) == SQLITE_OK {
                    while sqlite3_step(stmt2) == SQLITE_ROW {
                        for i in 0 ..< sqlite3_column_count(stmt2) {
                            let columnName = String(cString: sqlite3_column_name(stmt2, i))
                            let columnText = String(cString: sqlite3_column_text(stmt2, i))
                            print("\(columnName): \(columnText)")
                        }
                    }
                    sqlite3_finalize(stmt2)
                } else {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("error preparing select: \(errmsg)")
                }
            }
            sqlite3_finalize(stmt)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
    }

    func showAllTablesInfo() {
        var statement: OpaquePointer?
        let query = "SELECT name FROM sqlite_master WHERE type ='table';"

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let tableName = String(cString: sqlite3_column_text(statement, 0))
                self.showTableInfo(tableName: tableName)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing select: \(err)")
        }
        sqlite3_finalize(statement)
    }

    func showTableInfo(tableName: String) {
        var statement: OpaquePointer?
        let query = "PRAGMA table_info(\(tableName));"

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let columnName = String(cString: sqlite3_column_text(statement, 1))
                let columnType = String(cString: sqlite3_column_text(statement, 2))
                print("Table: \(tableName), Column: \(columnName), Type: \(columnType)")
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing pragma: \(err)")
        }
        sqlite3_finalize(statement)
    }

    func printColumnNames(table: String, db: OpaquePointer?) {
        var queryStatement: OpaquePointer?
        let query = "PRAGMA table_info(\(table));"

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                print(name)
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing statement: \(errmsg)")
        }

        sqlite3_finalize(queryStatement)
    }

    // MARK: Record

//    func saveData<T: Codable & Nameable>(data: [T], tableName: String, completion: @escaping () -> Void) {
//        let query = "INSERT OR REPLACE INTO \(tableName) (id, itemData) VALUES (?,?)"
//
//        for item in data {
//            var statement: OpaquePointer?
//            do {
//                let itemData = try JSONEncoder().encode(item)
//                guard let dataToString = String(data: itemData, encoding: .utf8) else { return }
//
//                if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
//                    sqlite3_bind_text(statement, 1, NSString(string: item.name).utf8String, -1, nil)
//                    sqlite3_bind_text(statement, 2, NSString(string: dataToString).utf8String, -1, nil)
//
//                    if sqlite3_step(statement) == SQLITE_DONE {
//                        print("insert data success")
//                    } else {
//                        print("insert data sqlite3 step fail")
//                    }
//
//                } else {
//                    let err = String(cString: sqlite3_errmsg(self.db))
//                    print("failure preparing insert: \(err)")
//                }
//                sqlite3_finalize(statement)
//            } catch {
//                print("JsonEncoder Error")
//            }
//        }
//        completion()
//    }

    func encodeToJson<T: Encodable>(_ value: T) -> String? {
        guard let encodedData = try? JSONEncoder().encode(value),
              let jsonString = String(data: encodedData, encoding: .utf8) else { return nil }
        return jsonString
    }

    func executeQuery(query: String, values: [String?], db: OpaquePointer?) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            for (index, value) in values.enumerated() {
                sqlite3_bind_text(statement, Int32(index + 1), NSString(string: value ?? "").utf8String, -1, nil)
            }
            if sqlite3_step(statement) == SQLITE_DONE {
                print("insert data success")
            } else {
                print("insert data sqlite3 step fail")
            }
        } else {
            let err = String(cString: sqlite3_errmsg(db))
            print("failure preparing save: \(err)")
        }
        sqlite3_finalize(statement)
    }

    func saveData(data: [DictItem], completion: @escaping () -> Void) {
        let query = "INSERT OR REPLACE INTO dictItemTable (name, code, division, mainCategory, subCategory, defaultValues, detailValues, dropTable) VALUES (?,?,?,?,?,?,?,?)"

        for item in data {
            let defaultValuesString = self.encodeToJson(item.defaultValues)
            let detailValuesString = self.encodeToJson(item.detailValues)
            let dropTableString = self.encodeToJson(item.dropTable)
            let values = [item.name, item.code, item.division, item.mainCategory, item.subCategory, defaultValuesString, detailValuesString, dropTableString]
            self.executeQuery(query: query, values: values, db: self.db)
        }
        completion()
    }

    func saveData(data: [DictMonster], completion: @escaping () -> Void) {
        let query = "INSERT OR REPLACE INTO dictMonsterTable (code, name, defaultValues, detailValues, hauntArea, dropTable) VALUES (?,?,?,?,?,?)"

        for item in data {
            let defaultValuesString = self.encodeToJson(item.defaultValues)
            let detailValuesString = self.encodeToJson(item.detailValues)
            let hauntAreaString = self.encodeToJson(item.hauntArea)
            let dropTableString = self.encodeToJson(item.dropTable)
            let values = [item.code, item.name, defaultValuesString, detailValuesString, hauntAreaString, dropTableString]
            self.executeQuery(query: query, values: values, db: self.db)
        }
        completion()
    }

    func saveData(data: [DictMap], completion: @escaping () -> Void) {
        let query = "INSERT OR REPLACE INTO dictMapTable (code, name, monsters, npcs) VALUES (?,?,?,?)"

        for item in data {
            let monstersString = self.encodeToJson(item.monsters)
            let npcsString = self.encodeToJson(item.npcs)
            let values = [item.code, item.name, monstersString, npcsString]
            self.executeQuery(query: query, values: values, db: self.db)
        }
        completion()
    }

    func saveData(data: [DictNPC], completion: @escaping () -> Void) {
        let query = "INSERT OR REPLACE INTO dictNPCTable (code, name, maps, quests) VALUES (?,?,?,?)"

        for item in data {
            let mapsString = self.encodeToJson(item.maps)
            let questsString = self.encodeToJson(item.quests)
            let values = [item.code, item.name, mapsString, questsString]
            self.executeQuery(query: query, values: values, db: self.db)
        }
        completion()
    }

    func saveData(data: [DictQuest], completion: @escaping () -> Void) {
        let query = "INSERT OR REPLACE INTO dictQuestTable (code, name, preQuest, currentQuest, laterQuest, times, defaultValues, rollToStart, toCompletion, reward) VALUES (?,?,?,?,?,?,?,?,?,?)"

        for item in data {
            let defaultValuesString = self.encodeToJson(item.defaultValues)
            let rollToStartString = self.encodeToJson(item.rollToStart)
            let toCompletionString = self.encodeToJson(item.toCompletion)
            let rewardString = self.encodeToJson(item.reward)
            let values = [item.code, item.name, item.preQuest, item.currentQuest, item.laterQuest, item.times, defaultValuesString, rollToStartString, toCompletionString, rewardString]
            self.executeQuery(query: query, values: values, db: self.db)
        }
        completion()
    }

//    func fetchId(tableName: String, completion: @escaping (String) -> Void) {
//        let query = "SELECT id FROM \(tableName)"
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
//            while sqlite3_step(statement) == SQLITE_ROW {
//                if let cString = sqlite3_column_text(statement, 0) {
//                    let id = String(cString: cString)
//                    completion(id)
//                }
//            }
//        } else {
//            let err = String(cString: sqlite3_errmsg(self.db))
//            print("failure preparing readId: \(err)")
//        }
//
//        sqlite3_finalize(statement)
//    }

//    func fetchData<T: Codable>(tableName: String, completion: @escaping ([T]) -> Void) {
//        let query = "SELECT * FROM \(tableName)"
//        var statement: OpaquePointer?
//        var result: [T] = []
//
//        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
//            while sqlite3_step(statement) == SQLITE_ROW {
//                guard let dataToString = String(cString: sqlite3_column_text(statement, 1)).data(using: .utf8) else { return }
//                if let jsonString = String(data: dataToString, encoding: .utf8) {
//                       print("Data to string: \(jsonString)")  // 이 부분 수정
//                   }
//                do {
//                    let data = try JSONDecoder().decode(T.self, from: dataToString)
//                    result.append(data)
//                } catch {
//                    print("JSON decoding error: \(error)")
//                    let err = String(cString: sqlite3_errmsg(self.db))
//                    print("failure preparing decoding: \(err)")
//                }
//            }
//        } else {
//            let err = String(cString: sqlite3_errmsg(self.db))
//            print("failure preparing readData: \(err)")
//        }
//        sqlite3_finalize(statement)
//        completion(result)
//    }

    func fetchDictItems(completion: @escaping ([DictItem]) -> Void) {
        let query = "SELECT * FROM dictItemTable"
        var statement: OpaquePointer?
        var result: [DictItem] = []

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let item = decodeItem(statement: statement)
                result.append(item)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch items: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }
    
    func fetchDictMonsters(completion: @escaping ([DictMonster]) -> Void) {
        let query = "SELECT * FROM dictMonsterTable"
        var statement: OpaquePointer?
        var result: [DictMonster] = []

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let monster = decodeMonster(statement: statement)
                result.append(monster)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch monsters: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }
    
    

    func fetchDictMaps(completion: @escaping ([DictMap]) -> Void) {
        let query = "SELECT * FROM dictMapTable"
        var statement: OpaquePointer?
        var result: [DictMap] = []

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let map = decodeMap(statement: statement)
                result.append(map)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch maps: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }

    func fetchDictNPCs(completion: @escaping ([DictNPC]) -> Void) {
        let query = "SELECT * FROM dictNPCTable"
        var statement: OpaquePointer?
        var result: [DictNPC] = []

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let npc = decodeNPC(statement: statement)
                result.append(npc)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch npcs: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }

    func fetchDictQuests(completion: @escaping ([DictQuest]) -> Void) {
        let query = "SELECT * FROM dictQuestsTable"
        var statement: OpaquePointer?
        var result: [DictQuest] = []

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let quest = decodeQuest(statement: statement)
                result.append(quest)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch quests: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }

    func searchData<T: Codable>(tableName: Filename, dataName: String, completion: @escaping ([T]) -> Void) {
        let query = "SELECT * FROM \(tableName.tableName) WHERE name = '\(dataName)'"
        var statement: OpaquePointer?
        var result: [T] = []

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                switch tableName {
                case .items:
                    guard let data = decodeItem(statement: statement) as? T else { return }
                    result.append(data)
                case .monsters:
                    guard let data = decodeMonster(statement: statement) as? T else { return }
                    result.append(data)
                case .maps:
                    print("quest")
                case .npcs:
                    print("quest")
                case .quests:
                    print("quest")
                }
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing search: \(err)")
        }
        sqlite3_finalize(statement)
        completion(result)
    }
    
    func deleteData(tableName: String, dataName: String, completion: @escaping () -> Void) {
        let query = "DELETE FROM \(tableName) WHERE name = '\(dataName)'"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete data success")
            } else {
                print("delete data step fail")
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing delete: \(err)")
        }
        sqlite3_finalize(statement)
        completion()
    }

    func updateData(tableName: Filename, itemName: String, fieldName: String, newValue: String, completion: @escaping () -> Void) {
        let query = "UPDATE \(tableName.tableName) SET \(fieldName) = ? WHERE name = ?"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: newValue).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, NSString(string: itemName).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("success updateData")
                completion()
            } else {
                print("updateData sqlite3 step fail")
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing update: \(err)")
        }
    }
    
    enum SortMenu {
        case level
        case str
        case dex
        case int
        case luk
    }
    
    enum OrderMenu {
        case ASC
        case DESC
    }
    
    func testItem(completion: @escaping ([DictItem]) -> Void) {
        let query = "SELECT * FROM dictItemTable, json_each(dictItemTable.defaultValues) WHERE json_extract(json_each.value, '$.name') = '1번 아이템 밸류' AND json_extract(json_each.value, '$.description') = '1번 아이템 밸류 설명'"
        var statement: OpaquePointer?
        var result: [DictItem] = []
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let items = decodeItem(statement: statement)
                result.append(items)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch items: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }
    
    func sortItem(field: SortMenu, order: OrderMenu, completion: @escaping ([DictItem]) -> Void) {
        let query = "SELECT * FROM dictItemTable ORDER BY \(field) \(order)"
        var statement: OpaquePointer?
        var result: [DictItem] = []

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let items = decodeItem(statement: statement)
                result.append(items)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch items: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }
    
    func filterItem(division: String, mainCategory: String, subCategory: String, completion: @escaping ([DictItem]) -> Void) {
        let query = "SELECT * FROM dictItemTable WHERE division = \(division) AND mainCategory = \(mainCategory) AND subCategory = \(subCategory)"
        var statement: OpaquePointer?
        var result: [DictItem] = []

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let items = decodeItem(statement: statement)
                result.append(items)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch items: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }
    
    func filterMonster(completion: @escaping ([DictMonster]) -> Void) {
        let query = "SELECT * FROM dictMonsterTable"
        var statement: OpaquePointer?
        var result: [DictMonster] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let statement = statement else { return }
                let monsters = decodeMonster(statement: statement)
                result.append(monsters)
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing fetch items: \(err)")
        }

        sqlite3_finalize(statement)
        completion(result)
    }
}

// MARK: decode
extension SqliteManager {
    func decodeItem(statement: OpaquePointer) -> DictItem {
        let name = String(cString: sqlite3_column_text(statement, 0))
        let code = String(cString: sqlite3_column_text(statement, 1))
        let division = String(cString: sqlite3_column_text(statement, 2))
        let mainCategory = String(cString: sqlite3_column_text(statement, 3))
        let subCategory = String(cString: sqlite3_column_text(statement, 4))

        let defaultValuesData = String(cString: sqlite3_column_text(statement, 5)).data(using: .utf8)!
        let defaultValues = try! JSONDecoder().decode([DictionaryNameDescription].self, from: defaultValuesData)

        let detailValuesData = String(cString: sqlite3_column_text(statement, 6)).data(using: .utf8)!
        let detailValues = try! JSONDecoder().decode([DictionaryNameDescription].self, from: detailValuesData)

        let dropTableData = String(cString: sqlite3_column_text(statement, 7)).data(using: .utf8)!
        let dropTable = try! JSONDecoder().decode([DictionaryNameDescription].self, from: dropTableData)

        return DictItem(name: name, code: code, division: division, mainCategory: mainCategory, subCategory: subCategory, defaultValues: defaultValues, detailValues: detailValues, dropTable: dropTable)

    }

    func decodeMonster(statement: OpaquePointer) -> DictMonster {
        let code = String(cString: sqlite3_column_text(statement, 0))
        let name = String(cString: sqlite3_column_text(statement, 1))
        
        let defaultValuesData = String(cString: sqlite3_column_text(statement, 2)).data(using: .utf8)!
        let defaultValues = try! JSONDecoder().decode([DictionaryNameDescription].self, from: defaultValuesData)

        let detailValuesData = String(cString: sqlite3_column_text(statement, 3)).data(using: .utf8)!
        let detailValues = try! JSONDecoder().decode([DictionaryNameDescription].self, from: detailValuesData)

        let hauntAreaData = String(cString: sqlite3_column_text(statement, 4)).data(using: .utf8)!
        let hauntArea = try! JSONDecoder().decode([String].self, from: hauntAreaData)

        let dropTableData = String(cString: sqlite3_column_text(statement, 5)).data(using: .utf8)!
        let dropTable = try! JSONDecoder().decode([DictionaryNameDescription].self, from: dropTableData)

        return DictMonster(code: code, name: name, defaultValues: defaultValues, detailValues: detailValues, hauntArea: hauntArea, dropTable: dropTable)
    }
    
    func decodeMap(statement: OpaquePointer) -> DictMap {
        let code = String(cString: sqlite3_column_text(statement, 0))
        let name = String(cString: sqlite3_column_text(statement, 1))

        let monstersData = String(cString: sqlite3_column_text(statement, 2)).data(using: .utf8)!
        let monsters = try! JSONDecoder().decode([DictionaryNameDescription].self, from: monstersData)

        let npcsData = String(cString: sqlite3_column_text(statement, 3)).data(using: .utf8)!
        let npcs = try! JSONDecoder().decode([String].self, from: npcsData)

        return DictMap(code: code, name: name, monsters: monsters, npcs: npcs)
    }
    
    func decodeNPC(statement: OpaquePointer) -> DictNPC {
        let code = String(cString: sqlite3_column_text(statement, 0))
        let name = String(cString: sqlite3_column_text(statement, 1))

        let mapsData = String(cString: sqlite3_column_text(statement, 2)).data(using: .utf8)!
        let maps = try! JSONDecoder().decode([String].self, from: mapsData)

        let questsData = String(cString: sqlite3_column_text(statement, 3)).data(using: .utf8)!
        let quests = try! JSONDecoder().decode([String].self, from: questsData)

        return DictNPC(code: code, name: name, maps: maps, quests: quests)
    }
    
    func decodeQuest(statement: OpaquePointer) -> DictQuest {
        let code = String(cString: sqlite3_column_text(statement, 0))
        let name = String(cString: sqlite3_column_text(statement, 1))

        let preQuest = String(cString: sqlite3_column_text(statement, 2))
        let currentQuest = String(cString: sqlite3_column_text(statement, 3))
        let laterQuest = String(cString: sqlite3_column_text(statement, 4))

        let times = String(cString: sqlite3_column_text(statement, 5))

        let defaultValuesData = String(cString: sqlite3_column_text(statement, 6)).data(using: .utf8)!
        let defaultValues = try! JSONDecoder().decode([DictionaryNameDescription].self, from: defaultValuesData)

        let rollToStartData = String(cString: sqlite3_column_text(statement, 7)).data(using: .utf8)!
        let rollToStart = try! JSONDecoder().decode([String].self, from: rollToStartData)

        let toCompletionData = String(cString: sqlite3_column_text(statement, 8)).data(using: .utf8)!
        let toCompletion = try! JSONDecoder().decode([DictionaryNameDescription].self, from: toCompletionData)

        let rewardData = String(cString: sqlite3_column_text(statement, 9)).data(using: .utf8)!
        let reward = try! JSONDecoder().decode([DictionaryNameDescription].self, from: rewardData)

        return DictQuest(code: code, name: name, preQuest: preQuest, currentQuest: currentQuest, laterQuest: laterQuest, times: times, defaultValues: defaultValues, rollToStart: rollToStart, toCompletion: toCompletion, reward: reward)
    }
}
