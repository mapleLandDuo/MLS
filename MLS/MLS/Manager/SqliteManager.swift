//
//  SqliteManager.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/02/18.
//

import Foundation

import SQLite3

class SqliteManager {
    var db: OpaquePointer?
    var path = "mlsDatabase.db"
    
    init() {
        self.db = self.createDB()
    }
    
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
    
    func createTable(tableName: String) {
        let query = "create table if not exists \(tableName) (id text primary key, itemData text)"
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
    
    func insertData<T: Codable>(data: T, id: String, tableName: String, completion: @escaping () -> Void) {
        let query = "insert or replace into \(tableName) (id, itemData) values (?,?)"
        var statement: OpaquePointer?

        do {
            let data = try JSONEncoder().encode(data)
            let dataToString = String(data: data, encoding: .utf8)
            
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, NSString(string: id).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, NSString(string: dataToString!).utf8String, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("insert data success")
                } else {
                    print("insert data sqlite3 step fail")
                }
                
            } else {
                print("insert Data prepare fail")
            }
            sqlite3_finalize(statement)
            completion()
        } catch {
            print("JsonEncoder Error")
        }
    }
    
    func readId(tableName: String, completion: @escaping (String) -> Void) {
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
            print("SELECT statement could not be prepared")
        }

        sqlite3_finalize(statement)
    }
    
    func readData<T: Codable>(tableName: String, completion: @escaping ([T]) -> Void) {
        let query = "select * from \(tableName)"
        var statement: OpaquePointer?
        var result: [T] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let overallData = String(cString: sqlite3_column_text(statement, 1))
                do {
                    let data = try JSONDecoder().decode(T.self, from: overallData.data(using: .utf8)!)
                    result.append(data)
                } catch {
                    print("JSONDecoder Error")
                }
            }
        } else {
            print("read Data prepare fail")
        }
        sqlite3_finalize(statement)
        completion(result)
    }
    
    func deleteData(tableName: String, dataName: String, completion: @escaping () -> Void) {
        let query = "delete from \(tableName) where id = '\(dataName)'"
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
            return
                print("delete data prepare fail")
        }
        sqlite3_finalize(statement)
        completion()
    }
    
    func updateData<T: Codable>(tableName: String, newItem: T, dataName: String, completion: @escaping () -> Void) {
        let query = "update \(tableName) set itemData = \(newItem) where id = \(dataName)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("success updateData")
                completion()
            } else {
                print("updataData sqlite3 step fail")
            }
        } else {
            print("updateData prepare fail")
        }
    }
}
