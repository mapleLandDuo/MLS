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
    func createTable(tableName: String) {
        let query = "CREATE TABLE IF NOT EXISTS \(tableName) (id TEXT PRIMARY KEY, itemData TEXT)"
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

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let name = String(cString: sqlite3_column_text(stmt, 0))
                print("name", name)
                let query = "SELECT * FROM \(name);"
                
                if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        // 각 컬럼에 대해
                        for i in 0..<sqlite3_column_count(stmt) {
                            let columnName = String(cString: sqlite3_column_name(stmt, i))
                            let columnText = String(cString: sqlite3_column_text(stmt, i))
                            print("\(columnName): \(columnText)")
                        }
                    }
                } else {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("error preparing select: \(errmsg)")
                }
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
    }
    
    // MARK: Column

    func saveData<T: Codable & Nameable>(data: [T], tableName: String, completion: @escaping () -> Void) {
        let query = "INSERT OR REPLACE INTO \(tableName) (id, itemData) VALUES (?,?)"
        
        for item in data {
            var statement: OpaquePointer?
            do {
                let itemData = try JSONEncoder().encode(item)
                guard let dataToString = String(data: itemData, encoding: .utf8) else { return }
                
                if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_text(statement, 1, NSString(string: item.name).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 2, NSString(string: dataToString).utf8String, -1, nil)
                    
                    if sqlite3_step(statement) == SQLITE_DONE {
                        print("insert data success")
                    } else {
                        print("insert data sqlite3 step fail")
                    }
                    
                } else {
                    let err = String(cString: sqlite3_errmsg(self.db))
                    print("failure preparing insert: \(err)")
                }
                sqlite3_finalize(statement)
            } catch {
                print("JsonEncoder Error")
            }
        }
        completion()
    }
    
    func fetchId(tableName: String, completion: @escaping (String) -> Void) {
        let query = "SELECT id FROM \(tableName)"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let cString = sqlite3_column_text(statement, 0) {
                    let id = String(cString: cString)
                    completion(id)
                }
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing readId: \(err)")
        }

        sqlite3_finalize(statement)
    }
    
    func fetchData<T: Codable>(tableName: String, completion: @escaping ([T]) -> Void) {
        let query = "SELECT * FROM \(tableName)"
        var statement: OpaquePointer?
        var result: [T] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let dataToString = String(cString: sqlite3_column_text(statement, 1)).data(using: .utf8) else { return }
                do {
                    let data = try JSONDecoder().decode(T.self, from: dataToString)
                    result.append(data)
                } catch {
                    let err = String(cString: sqlite3_errmsg(self.db))
                    print("failure preparing decoding: \(err)")
                }
            }
        } else {
            let err = String(cString: sqlite3_errmsg(self.db))
            print("failure preparing readData: \(err)")
        }
        sqlite3_finalize(statement)
        completion(result)
    }
    
    func searchData<T: Codable>(tableName: String, dataName: String, completion: @escaping ([T]) -> Void) {
        let query = "SELECT * FROM \(tableName) WHERE id = '\(dataName)'"
        var statement: OpaquePointer?
        var result: [T] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                guard let dataToString = String(cString: sqlite3_column_text(statement, 1)).data(using: .utf8) else { return }
                do {
                    let data = try JSONDecoder().decode(T.self, from: dataToString)
                    result.append(data)
                } catch {
                    print("JSONDecoder Error")
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
        let query = "DELETE FROM \(tableName) WHERE id = '\(dataName)'"
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
    
    func updateData<T: Codable>(tableName: String, newItem: T, id: String, completion: @escaping () -> Void) {
        let query = "UPDATE \(tableName) SET itemData = ? WHERE id = ?"
        var statement: OpaquePointer?
        do {
            let data = try JSONEncoder().encode(newItem)
            guard let newItemtoString = String(data: data, encoding: .utf8) else { return }
            
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, NSString(string: newItemtoString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, NSString(string: id).utf8String, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("success updateData")
                    completion()
                } else {
                    print("updataData sqlite3 step fail")
                }
            } else {
                let err = String(cString: sqlite3_errmsg(self.db))
                print("failure preparing update: \(err)")
            }
        } catch {
            print("JSONEncoder Error")
        }
    }
}
