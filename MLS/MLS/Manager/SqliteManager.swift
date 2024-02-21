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
        self.db = self.createDB()
    }

    // MARK: Database
    func createDB() -> Connection? {
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.path)
            let db = try Connection(filePath.path)
            print("Success create db Path")
            return db
        } catch {
            print("error in createDB - \(error)")
        }
        return nil
    }

    // MARK: Table
    func createTable(tableName: String, columnNames: [String]) {
        let table = Table(tableName)
        let createTable = table.create { table in
            print("table table", table)
            for columnName in columnNames {
                let column = Expression<String>(columnName)
                table.column(column)
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

    func fetchTables() {
        do {
            let tableNames = try db!.prepare("SELECT name FROM sqlite_master WHERE type='table'")

            for tableName in tableNames {
                print("Table: \(tableName[0]!)")
                let table = Table(tableName[0]! as! String)
                let rows = try db!.prepare(table.select(*))

                for row in rows {
                    print("Row: \(row)")
                }
            }
        } catch {
            print("fetch tables fail: \(error)")
        }
    }

    // MARK: Record
//    func saveData<T: Sqlable>(data: [T], completion: @escaping () -> Void) {
//        switch data {
//        case is [DictItem]:
//            let columns = DictItem.columnOrder.joined(separator: ", ")
//            let placeholders = String(repeating: "?, ", count: DictItem.columnOrder.count).dropLast(2)
//            let query = "INSERT OR REPLACE INTO dictItemTable (\(columns)) VALUES (\(placeholders))"
//
//            for item in data {
//                let values = encodeData(item: item)
//                do {
//                    let statement = try db?.prepare(query)
//                    try statement?.run(values)
//                    print("insert data success")
//                } catch {
//                    print("failure preparing save: \(error)")
//                }
//            }
//            completion()
//        case is [DictMonster]:
//            let columns = DictMonster.columnOrder.joined(separator: ", ")
//            let placeholders = String(repeating: "?, ", count: DictMonster.columnOrder.count).dropLast(2)
//            let query = "INSERT OR REPLACE INTO dictMonsterTable (\(columns)) VALUES (\(placeholders))"
//
//            for item in data {
//                let values = encodeData(item: item)
//                do {
//                    let statement = try db?.prepare(query)
//                    try statement?.run(values)
//                    print("insert data success")
//                } catch {
//                    print("failure preparing save: \(error)")
//                }
//            }
//            completion()
//        case is [DictMap]:
//            let columns = DictMap.columnOrder.joined(separator: ", ")
//            let placeholders = String(repeating: "?, ", count: DictMap.columnOrder.count).dropLast(2)
//            let query = "INSERT OR REPLACE INTO dictMapTable (\(columns)) VALUES (\(placeholders))"
//
//            for item in data {
//                let values = encodeData(item: item)
//                do {
//                    let statement = try db?.prepare(query)
//                    try statement?.run(values)
//                    print("insert data success")
//                } catch {
//                    print("failure preparing save: \(error)")
//                }
//            }
//            completion()
//        case is [DictNPC]:
//            let columns = DictNPC.columnOrder.joined(separator: ", ")
//            let placeholders = String(repeating: "?, ", count: DictNPC.columnOrder.count).dropLast(2)
//            let query = "INSERT OR REPLACE INTO dictNPCTable (\(columns)) VALUES (\(placeholders))"
//
//            for item in data {
//                let values = encodeData(item: item)
//                do {
//                    let statement = try db?.prepare(query)
//                    try statement?.run(values)
//                    print("insert data success")
//                } catch {
//                    print("failure preparing save: \(error)")
//                }
//            }
//            completion()
//        case is [DictQuest]:
//            insertTable(data: data)
//            let columns = DictQuest.columnOrder.joined(separator: ", ")
//            let placeholders = String(repeating: "?, ", count: DictQuest.columnOrder.count).dropLast(2)
//            let query = "INSERT OR REPLACE INTO dictQuestTable (\(columns)) VALUES (\(placeholders))"
//
//            for item in data {
//                let values = encodeData(item: item)
//                do {
//                    let statement = try db?.prepare(query)
//                    try statement?.run(values)
//                    print("insert data success")
//                } catch {
//                    print("failure preparing save: \(error)")
//                }
//            }
//            completion()
//        default:
//            break
//        }
//    }
    
    func saveData<T: Sqlable>(data: [T], completion: @escaping () -> Void) {
        let columns = T.columnOrder.joined(separator: ", ")
        let placeholders = String(repeating: "?, ", count: T.columnOrder.count).dropLast(2)
        let query = "INSERT OR REPLACE INTO \(T.tableName.tableName) (\(columns)) VALUES (\(placeholders))"
        for item in data {
            let values = encodeData(item: item)
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

//    func saveData(data: [DictItem], completion: @escaping () -> Void) {
//        let columns = DictItem.columnOrder.joined(separator: ", ")
//        let placeholders = String(repeating: "?, ", count: DictItem.columnOrder.count).dropLast(2)
//        let query = "INSERT OR REPLACE INTO dictItemTable (\(columns)) VALUES (\(placeholders))"
//
//        for item in data {
//            let values = encodeItem(item: item)
//            do {
//                let statement = try db?.prepare(query)
//                try statement?.run(values)
//                print("insert data success")
//            } catch {
//                print("failure preparing save: \(error)")
//            }
//        }
//        completion()
//    }
//
//    func saveData(data: [DictMonster], completion: @escaping () -> Void) {
//        let query = "INSERT OR REPLACE INTO dictMonsterTable (code, name, defaultValues, detailValues, hauntArea, dropTable) VALUES (?,?,?,?,?,?)"
//
//        for item in data {
//            let values = encodeMonster(item: item)
//            do {
//                let statement = try db?.prepare(query)
//                try statement?.run(values)
//                print("insert data success")
//            } catch {
//                print("failure preparing save: \(error)")
//            }
//        }
//        completion()
//    }
//
//    func saveData(data: [DictMap], completion: @escaping () -> Void) {
//        let query = "INSERT OR REPLACE INTO dictMapTable (code, name, monsters, npcs) VALUES (?,?,?,?)"
//
//        for item in data {
//            let monstersString = self.encodeToJson(item.monsters)
//            let npcsString = self.encodeToJson(item.npcs)
//            let values = [item.code, item.name, monstersString, npcsString]
//            do {
//                let statement = try db?.prepare(query)
//                try statement?.run(values)
//                print("insert data success")
//            } catch {
//                print("failure preparing save: \(error)")
//            }
//        }
//        completion()
//    }
//
//    func saveData(data: [DictNPC], completion: @escaping () -> Void) {
//        let query = "INSERT OR REPLACE INTO dictNPCTable (code, name, maps, quests) VALUES (?,?,?,?)"
//
//        for item in data {
//            let mapsString = self.encodeToJson(item.maps)
//            let questsString = self.encodeToJson(item.quests)
//            let values = [item.code, item.name, mapsString, questsString]
//            do {
//                let statement = try db?.prepare(query)
//                try statement?.run(values)
//                print("insert data success")
//            } catch {
//                print("failure preparing save: \(error)")
//            }
//        }
//        completion()
//    }
//
//    func saveData(data: [DictQuest], completion: @escaping () -> Void) {
//        let query = "INSERT OR REPLACE INTO dictQuestTable (code, name, preQuest, currentQuest, laterQuest, times, defaultValues, rollToStart, toCompletion, reward) VALUES (?,?,?,?,?,?,?,?,?,?)"
//
//        for item in data {
//            let defaultValuesString = self.encodeToJson(item.defaultValues)
//            let rollToStartString = self.encodeToJson(item.rollToStart)
//            let toCompletionString = self.encodeToJson(item.toCompletion)
//            let rewardString = self.encodeToJson(item.reward)
//            let values = [item.code, item.name, item.preQuest, item.currentQuest, item.laterQuest, item.times, defaultValuesString, rollToStartString, toCompletionString, rewardString]
//            do {
//                let statement = try db?.prepare(query)
//                try statement?.run(values)
//                print("insert data success")
//            } catch {
//                print("failure preparing save: \(error)")
//            }
//        }
//        completion()
//    }
    
    func fetchData<T: Sqlable>(completion: @escaping ([T]) -> Void) {
        var result: [T] = []
        let table = Table(T.tableName.tableName)

        do {
            for row in try self.db!.prepare(table) {
                switch T.tableName {
                case .items:
                    guard let data = decodeItem(row: row) as? T else { return }
                    result.append(data)
                case .monsters:
                    guard let data = decodeMonster(row: row) as? T else { return }
                    result.append(data)
                case .maps:
                    guard let data = decodeMap(row: row) as? T else { return }
                    result.append(data)
                case .npcs:
                    guard let data = decodeNPC(row: row) as? T else { return }
                    result.append(data)
                case .quests:
                    guard let data = decodeQuest(row: row) as? T else { return }
                    result.append(data)
                }
            }
        } catch {
            print("failure preparing fetch: \(error)")
        }

        completion(result)
    }
//
//    func fetchDictItems(completion: @escaping ([DictItem]) -> Void) {
//        var result: [DictItem] = []
//        do {
//            let dictItemTable = Table("dictItemTable")
//
//            for row in try self.db!.prepare(dictItemTable) {
//                guard let item = decodeItem(row: row) else { return }
//                result.append(item)
//            }
//        } catch {
//            print("failure preparing fetch items: \(error)")
//        }
//        completion(result)
//    }
//
//    func fetchDictMonsters(completion: @escaping ([DictMonster]) -> Void) {
//        var result: [DictMonster] = []
//        do {
//            let dictMonsterTable = Table("dictMonsterTable")
//
//            for row in try self.db!.prepare(dictMonsterTable) {
//                guard let monster = decodeMonster(row: row) else { return }
//                result.append(monster)
//            }
//        } catch {
//            print("failure preparing fetch monsters: \(error)")
//        }
//        completion(result)
//    }
//
//    func fetchDictMaps(completion: @escaping ([DictMap]) -> Void) {
//        var result: [DictMap] = []
//        do {
//            let dictMapTable = Table("dictMapTable")
//
//            for row in try self.db!.prepare(dictMapTable) {
//                guard let map = decodeMap(row: row) else { return }
//                result.append(map)
//            }
//        } catch {
//            print("failure preparing fetch maps: \(error)")
//        }
//        completion(result)
//    }
//
//    func fetchDictNPCs(completion: @escaping ([DictNPC]) -> Void) {
//        var result: [DictNPC] = []
//        do {
//            let dictNPCTable = Table("dictNPCTable")
//
//            for row in try self.db!.prepare(dictNPCTable) {
//                guard let npc = decodeNPC(row: row) else { return }
//                result.append(npc)
//            }
//        } catch {
//            print("failure preparing fetch npcs: \(error)")
//        }
//        completion(result)
//    }
//
//    func fetchDictQuests(completion: @escaping ([DictQuest]) -> Void) {
//        var result: [DictQuest] = []
//        do {
//            let dictQuestTable = Table("dictQuestTable")
//
//            for row in try self.db!.prepare(dictQuestTable) {
//                guard let quest = decodeQuest(row: row) else { return }
//                result.append(quest)
//            }
//        } catch {
//            print("failure preparing fetch quests: \(error)")
//        }
//        completion(result)
//    }

    func searchData<T: Sqlable>(dataName: String, completion: @escaping ([T]) -> Void) {
        var result: [T] = []

        do {
            let table = Table(T.tableName.tableName)

            let name = Expression<String>("name")

            for row in try self.db!.prepare(table.filter(name == dataName)) {
                switch T.tableName {
                case .items:
                    guard let data = decodeItem(row: row) as? T else { return }
                    result.append(data)
                case .monsters:
                    guard let data = decodeMonster(row: row) as? T else { return }
                    result.append(data)
                case .maps:
                    guard let data = decodeMap(row: row) as? T else { return }
                    result.append(data)
                case .npcs:
                    guard let data = decodeNPC(row: row) as? T else { return }
                    result.append(data)
                case .quests:
                    guard let data = decodeQuest(row: row) as? T else { return }
                    result.append(data)
                }
            }
        } catch {
            print("failure preparing search: \(error)")
        }
        completion(result)
    }

    func deleteData(tableName: Filename, dataName: String, completion: @escaping () -> Void) {
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

    func updateData(tableName: Filename, itemName: String, fieldName: String, newValue: String, completion: @escaping () -> Void) {
        do {
            let table = Table(tableName.tableName)

            let name = Expression<String>("name")
            let field = Expression<String>(fieldName)

            if try self.db!.run(table.filter(name == itemName).update(field <- newValue)) > 0 {
                print("success updateData")
            } else {
                print("updateData not found")
            }
        } catch {
            print("failure preparing update: \(error)")
        }
        completion()
    }

    // 필터링 아이템
    func filterItem(divisionName: String?, rollName: String?, minLv: Int?, maxLv: Int?, completion: @escaping ([DictItem]) -> Void) {
        var result: [DictItem] = []
        var index = 0
        var query = "SELECT * FROM dictItemTable"
        
        if let divisionName = divisionName {
            let escapedDataName = divisionName.replacingOccurrences(of: "'", with: "''")
            query += " WHERE division = '\(escapedDataName)'"
            index += 1
        }
        
        if let rollName = rollName {
            query = index == 0 ? query + " WHERE " : query + " AND "
            query += "EXISTS (SELECT * FROM json_each(dictItemTable.\(FieldMenu.detailValues)) WHERE json_extract(value, '$.name') = '직업' AND json_extract(value, '$.description') = '\(rollName)')"
            index += 1
        }
        
//        if let field2 = field2, let columnName2 = columnName2, let dataName2 = dataName2 {
//            let escapedDataName2 = dataName2.replacingOccurrences(of: "'", with: "''")
//            query = index == 0 ? query + " WHERE " : query + "AND "
//            query += "EXISTS (SELECT * FROM json_each(dictItemTable.\(field2)) WHERE json_extract(value, '$.name') = '\(columnName2)' AND json_extract(value, '$.description') = '\(escapedDataName2)')"
//            index += 1
//        }
        
        if let minLv = minLv, let maxLv = maxLv {
            query = index == 0 ? query + " WHERE " : query + "AND "
            query += "EXISTS (SELECT * FROM json_each(dictItemTable.\(FieldMenu.detailValues)) WHERE json_extract(value, '$.name') = 'LEVEL' AND CAST(json_extract(value, '$.description') AS INTEGER) BETWEEN \(minLv) AND \(maxLv))"
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
    func filterMonster(minLv: Int, maxLv: Int, completion: @escaping ([DictMonster]) -> Void) {
        var result: [DictMonster] = []
        let query = "SELECT * FROM (SELECT *, CAST(json_extract(value, '$.description') AS INTEGER) as level FROM dictMonsterTable, json_each(dictMonsterTable.defaultValues) WHERE json_extract(value, '$.name') = 'LEVEL') WHERE level BETWEEN \(minLv) AND \(maxLv) ORDER BY level ASC"
        
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
    
//    // 정렬 아이템
//    func sortItemByColumn(field: FieldMenu, sortMenu: SortMenu, order: OrderMenu, completion: @escaping ([DictItem]) -> Void) {
//        var result: [DictItem] = []
//
//        do {
//            let query = "SELECT * FROM ( SELECT *, CAST(json_extract(json_each.value, '$.\(field)') AS INTEGER) as description FROM dictItemTable, json_each(dictItemTable.\(field)) WHERE json_extract(json_each.value, '$.name') = '\(sortMenu.rawValue)') ORDER BY description \(order)"
//            for row in try self.db!.prepare(query) {
//                if let item = decodeItem(row: row) {
//                    result.append(item)
//                }
//            }
//        } catch {
//            print("Fetch failed: \(error)")
//        }
//
//        completion(result)
//    }
//
//    // 정렬 몬스터
//    func sortMonsterByColumn(field: FieldMenu, sortMenu: SortMenu, order: OrderMenu, completion: @escaping ([DictMonster]) -> Void) {
//        var result: [DictMonster] = []
//
//        do {
//            let query = "SELECT * FROM dictMonsterTable ORDER BY ( SELECT CAST(json_extract(value, '$.description') AS INTEGER) FROM json_each(dictMonsterTable.\(field)) WHERE json_extract(value, '$.name') = '\(sortMenu.rawValue)') \(order)"
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
    
    func sortItem<T: Sqlable>(field: FieldMenu, sortMenu: SortMenu, order: OrderMenu, completion: @escaping ([T]) -> Void) {
        var result: [T] = []

        do {
            let query = "SELECT * FROM \(T.tableName.tableName) ORDER BY ( SELECT CAST(json_extract(value, '$.description') AS INTEGER) FROM json_each(\(T.tableName.tableName).\(field)) WHERE json_extract(value, '$.name') = '\(sortMenu.rawValue)') \(order)"
            switch T.tableName {
            case .items:
                for row in try self.db!.prepare(query) {
                    if let item = decodeItem(row: row) as? T {
                        result.append(item)
                    }
                }
            case .monsters:
                for row in try self.db!.prepare(query) {
                    if let item = decodeMonster(row: row) as? T {
                        result.append(item)
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
            let nameValue = row[Expression<String>("name")]
            let codeValue = row[Expression<String>("code")]
            let divisionValue = row[Expression<String>("division")]
            let mainCategoryValue = row[Expression<String>("mainCategory")]
            let subCategoryValue = row[Expression<String>("subCategory")]

            let defaultValuesValue = self.decodeToJSON(row[Expression<String>("defaultValues")], type: [DictionaryNameDescription].self) ?? []
            let detailValuesValue = self.decodeToJSON(row[Expression<String>("detailValues")], type: [DictionaryNameDescription].self) ?? []
            let dropTableValue = self.decodeToJSON(row[Expression<String>("dropTable")], type: [DictionaryNameDescription].self) ?? []

            return DictItem(name: nameValue, code: codeValue, division: divisionValue, mainCategory: mainCategoryValue, subCategory: subCategoryValue, defaultValues: defaultValuesValue, detailValues: detailValuesValue, dropTable: dropTableValue)
        } else if let row = row as? [Binding?] {
            guard let nameValue = row[0] as? String,
                  let codeValue = row[1] as? String,
                  let divisionValue = row[2] as? String,
                  let mainCategoryValue = row[3] as? String,
                  let subCategoryValue = row[4] as? String,
                  let defaultValuesValue = self.decodeToJSON(row[5] as? String, type: [DictionaryNameDescription].self),
                  let detailValuesValue = self.decodeToJSON(row[6] as? String, type: [DictionaryNameDescription].self),
                  let dropTableValue = self.decodeToJSON(row[7] as? String, type: [DictionaryNameDescription].self)
            else {
                return nil
            }

            return DictItem(name: nameValue, code: codeValue, division: divisionValue, mainCategory: mainCategoryValue, subCategory: subCategoryValue, defaultValues: defaultValuesValue, detailValues: detailValuesValue, dropTable: dropTableValue)
        } else {
            return nil
        }
    }

    func decodeMonster(row: Any) -> DictMonster? {
        if let row = row as? Row {
            let codeValue = row[Expression<String>("code")]
            let nameValue = row[Expression<String>("name")]
            let defaultValue = self.decodeToJSON(row[Expression<String>("defaultValues")], type: [DictionaryNameDescription].self) ?? []
            let detailValue = self.decodeToJSON(row[Expression<String>("detailValues")], type: [DictionaryNameDescription].self) ?? []
            let hauntAreaValue = self.decodeToJSON(row[Expression<String>("hauntArea")], type: [String].self) ?? []
            let dropTableValue = self.decodeToJSON(row[Expression<String>("dropTable")], type: [DictionaryNameDescription].self) ?? []

            return DictMonster(code: codeValue, name: nameValue, defaultValues: defaultValue, detailValues: detailValue, hauntArea: hauntAreaValue, dropTable: dropTableValue)

        } else if let row = row as? [Binding?] {
            guard let codeValue = row[0] as? String,
                  let nameValue = row[1] as? String,
                  let defaultValues = self.decodeToJSON(row[2] as? String, type: [DictionaryNameDescription].self),
                  let detailValues = self.decodeToJSON(row[3] as? String, type: [DictionaryNameDescription].self),
                  let hauntArea = self.decodeToJSON(row[4] as? String, type: [String].self),
                  let dropTable = self.decodeToJSON(row[5] as? String, type: [DictionaryNameDescription].self)
            else {
                return nil
            }

            return DictMonster(code: codeValue, name: nameValue, defaultValues: defaultValues, detailValues: detailValues, hauntArea: hauntArea, dropTable: dropTable)
        } else {
            return nil
        }
    }

    func decodeMap(row: Any) -> DictMap? {
        if let row = row as? Row {
            let codeValue = row[Expression<String>("code")]
            let nameValue = row[Expression<String>("name")]
            let monstersValue = self.decodeToJSON(row[Expression<String>("monsters")], type: [DictionaryNameDescription].self) ?? []
            let npcsValue = self.decodeToJSON(row[Expression<String>("npcs")], type: [String].self) ?? []

            return DictMap(code: codeValue, name: nameValue, monsters: monstersValue, npcs: npcsValue)
        } else if let row = row as? [Binding?] {
            guard let codeValue = row[0] as? String,
                  let nameValue = row[1] as? String,
                  let monstersValue = self.decodeToJSON(row[2] as? String, type: [DictionaryNameDescription].self),
                  let npcsValue = self.decodeToJSON(row[3] as? String, type: [String].self)
            else {
                return nil
            }
            return DictMap(code: codeValue, name: nameValue, monsters: monstersValue, npcs: npcsValue)
        }
        return nil
    }

    func decodeNPC(row: Any) -> DictNPC? {
        if let row = row as? Row {
            let codeValue = row[Expression<String>("code")]
            let nameValue = row[Expression<String>("name")]
            let mapsValue = self.decodeToJSON(row[Expression<String>("maps")], type: [String].self) ?? []
            let questsValue = self.decodeToJSON(row[Expression<String>("quests")], type: [String].self) ?? []

            return DictNPC(code: codeValue, name: nameValue, maps: mapsValue, quests: questsValue)
        } else if let row = row as? [Binding?] {
            guard let codeValue = row[0] as? String,
                  let nameValue = row[1] as? String,
                  let mapsValue = self.decodeToJSON(row[3] as? String, type: [String].self),
                  let questsValue = self.decodeToJSON(row[4] as? String, type: [String].self)
            else {
                return nil
            }
            return DictNPC(code: codeValue, name: nameValue, maps: mapsValue, quests: questsValue)
        }
        return nil
    }

    func decodeQuest(row: Any) -> DictQuest? {
        if let row = row as? Row {
            let codeValue = row[Expression<String>("code")]
            let nameValue = row[Expression<String>("name")]
            let preQuestValue = row[Expression<String>("preQuest")]
            let currentQuestValue = row[Expression<String>("currentQuest")]
            let laterQuestValue = row[Expression<String>("laterQuest")]
            let timesValue = row[Expression<String>("times")]
            let defaultValuesValue = self.decodeToJSON(row[Expression<String>("defaultValues")], type: [DictionaryNameDescription].self) ?? []
            let rollToStartValue = self.decodeToJSON(row[Expression<String>("rollToStart")], type: [String].self) ?? []
            let toCompletionValue = self.decodeToJSON(row[Expression<String>("toCompletion")], type: [DictionaryNameDescription].self) ?? []
            let rewardValue = self.decodeToJSON(row[Expression<String>("reward")], type: [DictionaryNameDescription].self) ?? []

            return DictQuest(code: codeValue, name: nameValue, preQuest: preQuestValue, currentQuest: currentQuestValue, laterQuest: laterQuestValue, times: timesValue, defaultValues: defaultValuesValue, rollToStart: rollToStartValue, toCompletion: toCompletionValue, reward: rewardValue)
        } else if let row = row as? [Binding?] {
            guard let codeValue = row[0] as? String,
                  let nameValue = row[1] as? String,
                  let preQuestValue = row[2] as? String,
                  let currentQuestValue = row[3] as? String,
                  let laterQuestValue = row[4] as? String,
                  let timesValue = row[5] as? String,
                  let defaultValuesValue = self.decodeToJSON(row[6] as? String, type: [DictionaryNameDescription].self),
                  let rollToStartValue = self.decodeToJSON(row[7] as? String, type: [String].self),
                  let toCompletionValue = self.decodeToJSON(row[8] as? String, type: [DictionaryNameDescription].self),
                  let rewardValue = self.decodeToJSON(row[9] as? String, type: [DictionaryNameDescription].self)
            else {
                return nil
            }
            return DictQuest(code: codeValue, name: nameValue, preQuest: preQuestValue, currentQuest: currentQuestValue, laterQuest: laterQuestValue, times: timesValue, defaultValues: defaultValuesValue, rollToStart: rollToStartValue, toCompletion: toCompletionValue, reward: rewardValue)
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
//
//    func encodeItem(item: DictItem) -> [String?] {
//        let defaultValuesString = self.encodeToJson(item.defaultValues)
//        let detailValuesString = self.encodeToJson(item.detailValues)
//        let dropTableString = self.encodeToJson(item.dropTable)
//        return [item.name, item.code, item.division, item.mainCategory, item.subCategory, defaultValuesString, detailValuesString, dropTableString]
//    }
//
//    func encodeMonster(item: DictMonster) -> [String?] {
//        let defaultValuesString = self.encodeToJson(item.defaultValues)
//        let detailValuesString = self.encodeToJson(item.detailValues)
//        let hauntAreaString = self.encodeToJson(item.hauntArea)
//        let dropTableString = self.encodeToJson(item.dropTable)
//        return [item.code, item.name, defaultValuesString, detailValuesString, hauntAreaString, dropTableString]
//    }
//
//    func encodeMap(item: DictMap) -> [String?] {
//        let monstersString = self.encodeToJson(item.monsters)
//        let npcsString = self.encodeToJson(item.npcs)
//        return [item.code, item.name, monstersString, npcsString]
//    }
//
//    func encodeNPC(item: DictNPC) -> [String?] {
//        let mapsValue = self.encodeToJson(item.maps)
//        let questsValue = self.encodeToJson(item.quests)
//        return [item.code, item.name, mapsValue, questsValue]
//    }
//
//    func encodeQuest(item: DictQuest) -> [String?] {
//        let defaultValuesValue = self.encodeToJson(item.defaultValues)
//        let rollToStartValue = self.encodeToJson(item.rollToStart)
//        let toCompletionValue = self.encodeToJson(item.toCompletion)
//        let rewardValue = self.encodeToJson(item.reward)
//        return [item.code, item.name, item.preQuest, item.currentQuest, item.laterQuest, item.times, defaultValuesValue, rollToStartValue, toCompletionValue, rewardValue]
//    }
    
    func encodeData<T: Sqlable>(item: T) -> [String?] {
        switch item {
        case is DictItem:
            guard let item = item as? DictItem else { return [] }
            let defaultValuesString = self.encodeToJson(item.defaultValues)
            let detailValuesString = self.encodeToJson(item.detailValues)
            let dropTableString = self.encodeToJson(item.dropTable)
            return [item.name, item.code, item.division, item.mainCategory, item.subCategory, defaultValuesString, detailValuesString, dropTableString]
        case is DictMonster:
            guard let item = item as? DictMonster else { return [] }
            let defaultValuesString = self.encodeToJson(item.defaultValues)
            let detailValuesString = self.encodeToJson(item.detailValues)
            let hauntAreaString = self.encodeToJson(item.hauntArea)
            let dropTableString = self.encodeToJson(item.dropTable)
            return [item.code, item.name, defaultValuesString, detailValuesString, hauntAreaString, dropTableString]
        case is DictMap:
            guard let item = item as? DictMap else { return [] }
            let monstersString = self.encodeToJson(item.monsters)
            let npcsString = self.encodeToJson(item.npcs)
            return [item.code, item.name, monstersString, npcsString]
        case is DictNPC:
            guard let item = item as? DictNPC else { return [] }
            let mapsValue = self.encodeToJson(item.maps)
            let questsValue = self.encodeToJson(item.quests)
            return [item.code, item.name, mapsValue, questsValue]
        case is DictQuest:
            guard let item = item as? DictQuest else { return [] }
            let defaultValuesValue = self.encodeToJson(item.defaultValues)
            let rollToStartValue = self.encodeToJson(item.rollToStart)
            let toCompletionValue = self.encodeToJson(item.toCompletion)
            let rewardValue = self.encodeToJson(item.reward)
            return [item.code, item.name, item.preQuest, item.currentQuest, item.laterQuest, item.times, defaultValuesValue, rollToStartValue, toCompletionValue, rewardValue]
        default:
            return []
        }
    }
}

// MARK: Enum
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
