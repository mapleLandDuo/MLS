//
//  SqliteManager.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/18.
//

import Foundation

import SQLite

class SqliteManager {
    var db: Connection?
    let path = "mlsDatabase.db"

    init() {
//        self.db = self.createDB()
        self.db = self.connectToDB()
    }

    // MARK: Database
//    func createDB() -> Connection? {
//        do {
//            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.path)
//            let db = try Connection(filePath.path)
//            print("Success create db Path")
//            return db
//        } catch {
//            print("error in createDB - \(error)")
//        }
//        return nil
//    }

    func connectToDB() -> Connection? {
        let fileName = "mlsDatabase.db"
        let fileManager = FileManager.default
        guard let bundlePath = Bundle.main.path(forResource: "mlsDatabase", ofType: "db"),
              let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentPath.appendingPathComponent(fileName)

        if !fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: fileURL.path)
                print("Database file copied from bundle to document directory")
            } catch {
                print("Error: \(error)")
                return nil
            }
        }

        do {
            let db = try Connection(fileURL.path)
            print("Success connect to db")
            return db
        } catch {
            print("Error: \(error)")
        }
        return nil
    }

    // MARK: Table
    func createTable(tableName: String, columnNames: [String]) {
        let table = Table(tableName)
        let createTable = table.create { table in
            print("table table", table)
            for columnName in columnNames {
                let column = Expression<String?>(columnName)
                if columnName == "preQuest" || columnName == "laterQuest" {
                    table.column(column, defaultValue: nil)
                } else {
                    table.column(column)
                }
            }
        }
        do {
            try self.db?.run(createTable)
            print("테이블 생성 성공")
        } catch {
            print("테이블 생성 실패: \(error)")
        }
    }

    func deleteTable(tableName: String) {
        let table = Table(tableName)
        do {
            try self.db?.run(table.drop())
            print("delete table success")
        } catch {
            print("delete table fail: \(error)")
        }
    }

//    func fetchTables() {
//        do {
//            let tableNames = try db!.prepare("SELECT name FROM sqlite_master WHERE type='table'")
//
//            for tableName in tableNames {
//                print("Table: \(tableName[0]!)")
//                let table = Table(tableName[0]! as! String)
//                let rows = try db!.prepare(table.select(*))
//
//                for row in rows {
//                    print("Row: \(row)")
//                }
//            }
//        } catch {
//            print("fetch tables fail: \(error)")
//        }
//    }

    // MARK: Record

    func saveData<T: Sqlable>(data: [T], completion: @escaping () -> Void) {
        let columns = T.columnOrder.joined(separator: ", ")
        let placeholders = String(repeating: "?, ", count: T.columnOrder.count).dropLast(2)
        let query = "INSERT OR REPLACE INTO \(T.tableName.tableName) (\(columns)) VALUES (\(placeholders))"
        for item in data {
            var values = encodeData(item: item)
            if let item = item as? DictQuest {
                if T.columnOrder.contains("preQuest") {
                    values[T.columnOrder.firstIndex(of: "preQuest")!] = item.preQuest ?? ""
                }
                if T.columnOrder.contains("laterQuest") {
                    values[T.columnOrder.firstIndex(of: "laterQuest")!] = item.laterQuest ?? ""
                }
            }
            do {
                let statement = try db?.prepare(query)
                try statement?.run(values)
                print("insert data success")
            } catch {
                print("failure preparing save: \(error)")
            }
        }
        completion()
    }

    func fetchData<T: Sqlable>(completion: @escaping ([T]) -> Void) {
        var result: [T] = []
        let table = Table(T.tableName.tableName)

        do {
            for row in try self.db!.prepare(table) {
                switch T.tableName {
                case .item:
                    guard let data = decodeItem(row: row) as? T else { return }
                    result.append(data)
                case .monster:
                    guard let data = decodeMonster(row: row) as? T else { return }
                    result.append(data)
                case .map:
                    guard let data = decodeMap(row: row) as? T else { return }
                    result.append(data)
                case .npc:
                    guard let data = decodeNPC(row: row) as? T else { return }
                    result.append(data)
                case .quest:
                    guard let data = decodeQuest(row: row) as? T else { return }
                    result.append(data)
                }
            }
        } catch {
            print("failure preparing fetch: \(error)")
        }

        completion(result)
    }

    func searchData<T: Sqlable>(dataName: String, completion: @escaping ([T]) -> Void) {
        var result: [T] = []

        do {
            let table = Table(T.tableName.tableName)

            let name = Expression<String>("name")

            let query = table.filter(name.like("%\(dataName)%"))

            for row in try self.db!.prepare(query) {
                switch T.tableName {
                case .item:
                    guard let data = decodeItem(row: row) as? T else { return }
                    result.append(data)
                case .monster:
                    guard let data = decodeMonster(row: row) as? T else { return }
                    result.append(data)
                case .map:
                    guard let data = decodeMap(row: row) as? T else { return }
                    result.append(data)
                case .npc:
                    guard let data = decodeNPC(row: row) as? T else { return }
                    result.append(data)
                case .quest:
                    guard let data = decodeQuest(row: row) as? T else { return }
                    result.append(data)
                }
            }
        } catch {
            print("Failure preparing search: \(error)")
        }
        completion(result)
    }

    func searchDetailData<T: Sqlable>(dataName: String, completion: @escaping (T) -> Void) {
        do {
            let table = Table(T.tableName.tableName)

            let name = Expression<String>("name")

            let query = table.filter(name == dataName)

            for row in try self.db!.prepare(query) {
                switch T.tableName {
                case .item:
                    guard let data = decodeItem(row: row) as? T else { return }
                    completion(data)
                case .monster:
                    guard let data = decodeMonster(row: row) as? T else { return }
                    completion(data)
                case .map:
                    guard let data = decodeMap(row: row) as? T else { return }
                    completion(data)
                case .npc:
                    guard let data = decodeNPC(row: row) as? T else { return }
                    completion(data)
                case .quest:
                    guard let data = decodeQuest(row: row) as? T else { return }
                    completion(data)
                }
            }
        } catch {
            print("Failure preparing search: \(error)")
        }
    }

    func deleteData(tableName: DictType, dataName: String, completion: @escaping () -> Void) {
        do {
            let table = Table(tableName.tableName)

            let name = Expression<String>("name")

            if try self.db!.run(table.filter(name == dataName).delete()) > 0 {
                print("delete data success")
            } else {
                print("delete data not found")
            }
        } catch {
            print("failure preparing delete: \(error)")
        }
        completion()
    }

//    func updateData(tableName: Filename, itemName: String, fieldName: String, newValue: String, completion: @escaping () -> Void) {
//        do {
//            let table = Table(tableName.tableName)
//
//            let name = Expression<String>("name")
//            let field = Expression<String>(fieldName)
//
//            if try self.db!.run(table.filter(name == itemName).update(field <- newValue)) > 0 {
//                print("success updateData")
//            } else {
//                print("updateData not found")
//            }
//        } catch {
//            print("failure preparing update: \(error)")
//        }
//        completion()
//    }

    // 필터링 아이템

    func filterItem(searchKeyword: String?, divisionName: String?, rollName: String?, minLv: Int?, maxLv: Int?, completion: @escaping ([DictItem]) -> Void) {
        var result: [DictItem] = []
        var index = 0
        var query = "SELECT * FROM dictItemTable"

        if let searchKeyword = searchKeyword {
            query += " WHERE name LIKE '%\(searchKeyword)%'"
            index += 1
        }

        if let divisionName = divisionName {
            let divisionString = divisionName.replacingOccurrences(of: "'", with: "''")
            query = index == 0 ? query + " WHERE " : query + " AND "
            query += "division = '\(divisionString)'"
            index += 1
        }

        if let rollName = rollName {
            query = index == 0 ? query + " WHERE " : query + " AND "
            query += "EXISTS (SELECT * FROM json_each(dictItemTable.\(FieldMenu.detailValues)) WHERE json_extract(value, '$.name') = '직업' AND json_extract(value, '$.description') = '\(rollName)')"
            index += 1
        }

        if let minLv = minLv, let maxLv = maxLv {
            query = index == 0 ? query + " WHERE " : query + "AND "
            query += "EXISTS (SELECT * FROM json_each(dictItemTable.\(FieldMenu.defaultValues)) WHERE json_extract(value, '$.name') = 'LEVEL' AND CAST(json_extract(value, '$.description') AS INTEGER) BETWEEN \(minLv) AND \(maxLv))"
            index += 1
        }

        do {
            for row in try self.db!.prepare(query) {
                if let item = decodeItem(row: row) {
                    result.append(item)
                }
            }
        } catch {
            print("Fetch failed: \(error)")
        }
        completion(result)
    }

    // 필터링 몬스터

    func filterMonster(searchKeyword: String?, minLv: Int?, maxLv: Int?, completion: @escaping ([DictMonster]) -> Void) {
        var result: [DictMonster] = []
        var index = 0
        var query = "SELECT * FROM dictMonsterTable"

        if let searchKeyword = searchKeyword {
            query += " WHERE name LIKE '%\(searchKeyword)%'"
            index += 1
        }

        if let minLv = minLv, let maxLv = maxLv {
            query = index == 0 ? query + " WHERE " : query + "AND "
            query += "EXISTS (SELECT * FROM json_each(dictMonsterTable.\(FieldMenu.defaultValues)) WHERE json_extract(value, '$.name') = 'LEVEL' AND CAST(json_extract(value, '$.description') AS INTEGER) BETWEEN \(minLv) AND \(maxLv))"
            index += 1
        }

        do {
            for row in try self.db!.prepare(query) {
                if let item = decodeMonster(row: row) {
                    result.append(item)
                }
            }
        } catch {
            print("Fetch failed: \(error)")
        }

        completion(result)
    }

//    func filterMonster(minLv: Int, maxLv: Int, completion: @escaping ([DictMonster]) -> Void) {
//        var result: [DictMonster] = []
//        let query = "SELECT * FROM (SELECT *, CAST(json_extract(value, '$.description') AS INTEGER) as level FROM dictMonsterTable, json_each(dictMonsterTable.defaultValues) WHERE json_extract(value, '$.name') = 'LEVEL') WHERE level BETWEEN \(minLv) AND \(maxLv) ORDER BY level ASC"
//
//        do {
//            for row in try self.db!.prepare(query) {
//                if let item = decodeMonster(row: row) {
//                    result.append(item)
//                }
//            }
//        } catch {
//            print("Fetch failed: \(error)")
//        }
//
//        completion(result)
//    }

    // 정렬 아이템
    func sortItem<T: Sqlable>(field: FieldMenu, sortMenu: SortMenu, order: OrderMenu, completion: @escaping ([T]) -> Void) {
        var result: [T] = []

        do {
            let query = "SELECT * FROM \(T.tableName.tableName) ORDER BY ( SELECT CAST(json_extract(value, '$.description') AS INTEGER) FROM json_each(\(T.tableName.tableName).\(field)) WHERE json_extract(value, '$.name') = '\(sortMenu.rawValue)') \(order)"
            switch T.tableName {
            case .item:
                for row in try self.db!.prepare(query) {
                    if let data = decodeItem(row: row) as? T {
                        result.append(data)
                    }
                }
            case .monster:
                for row in try self.db!.prepare(query) {
                    if let data = decodeMonster(row: row) as? T {
                        result.append(data)
                    }
                }
            default:
                break
            }
        } catch {
            print("Fetch failed: \(error)")
        }

        completion(result)
    }
}

// MARK: decode / encode
extension SqliteManager {
    func decodeToJSON<T: Decodable>(_ jsonString: String?, type: T.Type) -> T? {
        guard let jsonString = jsonString,
              let jsonData = jsonString.data(using: .utf8)
        else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: jsonData)
    }

    func decodeItem(row: Any) -> DictItem? {
        if let row = row as? Row {
            let name = row[Expression<String>("name")]
            let code = row[Expression<String>("code")]
            let division = row[Expression<String>("division")]
            let mainCategory = row[Expression<String>("mainCategory")]
            let subCategory = row[Expression<String>("subCategory")]

            let defaultValues = self.decodeToJSON(row[Expression<String>("defaultValues")], type: [DictionaryNameDescription].self) ?? []
            let detailValues = self.decodeToJSON(row[Expression<String>("detailValues")], type: [DictionaryNameDescription].self) ?? []
            let dropTable = self.decodeToJSON(row[Expression<String>("dropTable")], type: [DictionaryNameDescription].self) ?? []

            return DictItem(name: name, code: code, division: division, mainCategory: mainCategory, subCategory: subCategory, defaultValues: defaultValues, detailValues: detailValues, dropTable: dropTable)
        } else if let row = row as? [Binding?] {
            guard let name = row[0] as? String,
                  let code = row[1] as? String,
                  let division = row[2] as? String,
                  let mainCategory = row[3] as? String,
                  let subCategory = row[4] as? String,
                  let defaultValues = self.decodeToJSON(row[5] as? String, type: [DictionaryNameDescription].self),
                  let detailValues = self.decodeToJSON(row[6] as? String, type: [DictionaryNameDescription].self),
                  let dropTable = self.decodeToJSON(row[7] as? String, type: [DictionaryNameDescription].self)
            else {
                return nil
            }

            return DictItem(name: name, code: code, division: division, mainCategory: mainCategory, subCategory: subCategory, defaultValues: defaultValues, detailValues: detailValues, dropTable: dropTable)
        } else {
            return nil
        }
    }

    func decodeMonster(row: Any) -> DictMonster? {
        if let row = row as? Row {
            let code = row[Expression<String>("code")]
            let name = row[Expression<String>("name")]
            let defaultValues = self.decodeToJSON(row[Expression<String>("defaultValues")], type: [DictionaryNameDescription].self) ?? []
            let detailValues = self.decodeToJSON(row[Expression<String>("detailValues")], type: [DictionaryNameDescription].self) ?? []
            let hauntArea = self.decodeToJSON(row[Expression<String>("hauntArea")], type: [String].self) ?? []
            let dropTable = self.decodeToJSON(row[Expression<String>("dropTable")], type: [DictionaryNameDescription].self) ?? []

            return DictMonster(code: code, name: name, defaultValues: defaultValues, detailValues: detailValues, hauntArea: hauntArea, dropTable: dropTable)

        } else if let row = row as? [Binding?] {
            guard let code = row[0] as? String,
                  let name = row[1] as? String,
                  let defaultValues = self.decodeToJSON(row[2] as? String, type: [DictionaryNameDescription].self),
                  let detailValues = self.decodeToJSON(row[3] as? String, type: [DictionaryNameDescription].self),
                  let hauntArea = self.decodeToJSON(row[4] as? String, type: [String].self),
                  let dropTable = self.decodeToJSON(row[5] as? String, type: [DictionaryNameDescription].self)
            else {
                return nil
            }

            return DictMonster(code: code, name: name, defaultValues: defaultValues, detailValues: detailValues, hauntArea: hauntArea, dropTable: dropTable)
        } else {
            return nil
        }
    }

    func decodeMap(row: Any) -> DictMap? {
        if let row = row as? Row {
            let code = row[Expression<String>("code")]
            let name = row[Expression<String>("name")]
            let monsters = self.decodeToJSON(row[Expression<String>("monsters")], type: [DictionaryNameDescription].self) ?? []
            let npcs = self.decodeToJSON(row[Expression<String>("npcs")], type: [String].self) ?? []

            return DictMap(code: code, name: name, monsters: monsters, npcs: npcs)
        } else if let row = row as? [Binding?] {
            guard let code = row[0] as? String,
                  let name = row[1] as? String,
                  let monsters = self.decodeToJSON(row[2] as? String, type: [DictionaryNameDescription].self),
                  let npcs = self.decodeToJSON(row[3] as? String, type: [String].self)
            else {
                return nil
            }
            return DictMap(code: code, name: name, monsters: monsters, npcs: npcs)
        }
        return nil
    }

    func decodeNPC(row: Any) -> DictNPC? {
        if let row = row as? Row {
            let code = row[Expression<String>("code")]
            let name = row[Expression<String>("name")]
            let maps = self.decodeToJSON(row[Expression<String>("maps")], type: [String].self) ?? []
            let quests = self.decodeToJSON(row[Expression<String>("quests")], type: [String].self) ?? []

            return DictNPC(code: code, name: name, maps: maps, quests: quests)
        } else if let row = row as? [Binding?] {
            guard let code = row[0] as? String,
                  let name = row[1] as? String,
                  let maps = self.decodeToJSON(row[3] as? String, type: [String].self),
                  let quests = self.decodeToJSON(row[4] as? String, type: [String].self)
            else {
                return nil
            }
            return DictNPC(code: code, name: name, maps: maps, quests: quests)
        }
        return nil
    }

    func decodeQuest(row: Any) -> DictQuest? {
        if let row = row as? Row {
            let code = row[Expression<String>("code")]
            let name = row[Expression<String>("name")]
            let preQuest = row[Expression<String>("preQuest")]
            let currentQuest = row[Expression<String>("currentQuest")]
            let laterQuest = row[Expression<String>("laterQuest")]
            let times = row[Expression<String>("times")]
            let defaultValues = self.decodeToJSON(row[Expression<String>("defaultValues")], type: [DictionaryNameDescription].self) ?? []
            let rollToStart = self.decodeToJSON(row[Expression<String>("rollToStart")], type: [String].self) ?? []
            let toCompletion = self.decodeToJSON(row[Expression<String>("toCompletion")], type: [DictionaryNameDescription].self) ?? []
            let reward = self.decodeToJSON(row[Expression<String>("reward")], type: [DictionaryNameDescription].self) ?? []

            return DictQuest(code: code, name: name, preQuest: preQuest, currentQuest: currentQuest, laterQuest: laterQuest, times: times, defaultValues: defaultValues, rollToStart: rollToStart, toCompletion: toCompletion, reward: reward)
        } else if let row = row as? [Binding?] {
            guard let code = row[0] as? String,
                  let name = row[1] as? String,
                  let preQuest = row[2] as? String,
                  let currentQuest = row[3] as? String,
                  let laterQuest = row[4] as? String,
                  let times = row[5] as? String,
                  let defaultValues = self.decodeToJSON(row[6] as? String, type: [DictionaryNameDescription].self),
                  let rollToStart = self.decodeToJSON(row[7] as? String, type: [String].self),
                  let toCompletion = self.decodeToJSON(row[8] as? String, type: [DictionaryNameDescription].self),
                  let reward = self.decodeToJSON(row[9] as? String, type: [DictionaryNameDescription].self)
            else {
                return nil
            }
            return DictQuest(code: code, name: name, preQuest: preQuest, currentQuest: currentQuest, laterQuest: laterQuest, times: times, defaultValues: defaultValues, rollToStart: rollToStart, toCompletion: toCompletion, reward: reward)
        }
        return nil
    }
}

// MARK: Encode
extension SqliteManager {
    func encodeToJson<T: Encodable>(_ value: T) -> String? {
        guard let encodedData = try? JSONEncoder().encode(value),
              let jsonString = String(data: encodedData, encoding: .utf8) else { return nil }
        return jsonString
    }

    func encodeData<T: Sqlable>(item: T) -> [String?] {
        switch item {
        case is DictItem:
            guard let item = item as? DictItem else { return [] }
            let defaultValues = self.encodeToJson(item.defaultValues)
            let detailValues = self.encodeToJson(item.detailValues)
            let dropTable = self.encodeToJson(item.dropTable)
            return [item.name, item.code, item.division, item.mainCategory, item.subCategory, defaultValues, detailValues, dropTable]
        case is DictMonster:
            guard let item = item as? DictMonster else { return [] }
            let defaultValues = self.encodeToJson(item.defaultValues)
            let detailValues = self.encodeToJson(item.detailValues)
            let hauntArea = self.encodeToJson(item.hauntArea)
            let dropTable = self.encodeToJson(item.dropTable)
            return [item.code, item.name, defaultValues, detailValues, hauntArea, dropTable]
        case is DictMap:
            guard let item = item as? DictMap else { return [] }
            let monsters = self.encodeToJson(item.monsters)
            let npcs = self.encodeToJson(item.npcs)
            return [item.code, item.name, monsters, npcs]
        case is DictNPC:
            guard let item = item as? DictNPC else { return [] }
            let maps = self.encodeToJson(item.maps)
            let quests = self.encodeToJson(item.quests)
            return [item.code, item.name, maps, quests]
        case is DictQuest:
            guard let item = item as? DictQuest else { return [] }
            let defaultValues = self.encodeToJson(item.defaultValues)
            let rollToStart = self.encodeToJson(item.rollToStart)
            let toCompletion = self.encodeToJson(item.toCompletion)
            let reward = self.encodeToJson(item.reward)
            return [item.code, item.name, item.preQuest, item.currentQuest, item.laterQuest, item.times, defaultValues, rollToStart, toCompletion, reward]
        default:
            return []
        }
    }
}

extension SqliteManager {
    enum SortMenu: String {
        // common
        case LEVEL
        // item
        case price = "상점 판매가"
        // monster
        case EXP
    }

    enum OrderMenu {
        case ASC
        case DESC
    }

    enum FieldMenu {
        case defaultValues
        case detailValues
    }
}
