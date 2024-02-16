//
//  DBHelper.swift
//  MLS
//
//  Created by SeoJunYoung on 2/14/24.
//

import Foundation

import SQLite3

class DBHelper {
    static let shared = DBHelper()
    
    var db: OpaquePointer?
    var path = "mySqlite.sqlite"
    
    init() {
        self.db = createDB()
    }
    
    func createDB() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
            if sqlite3_open(filePath.path, &db) == SQLITE_OK {
                print("Success create db Path")
                return db
            }
        }
        catch {
            print("error in createDB")
        }
        print("error in createDB - sqlite3_open")
        return nil
    }
    
    func createTable() {
        let query = "create table if not exists myDB (id INTEGER primary key autoincrement, itemData text)"
        var statement: OpaquePointer? = nil
        
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
    
    func deleteTable() {
        let query = "DROP TABLE myDB"
        var statement: OpaquePointer? = nil
        
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
    
    func insertData(_ overallData: DictionaryItem) {
        let query = "insert into myDB (id, itemData) values (?,?)"
        var statement: OpaquePointer? = nil

        do {
            let data = try JSONEncoder().encode(overallData)
            let dataToString = String(data: data, encoding: .utf8)
            
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
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
        }
        catch {
            print("JsonEncoder Error")
        }
    }
    
    func readData() ->[DictionaryItem] {
        let query = "select * from myDB"
        var statement: OpaquePointer? = nil
        var result: [DictionaryItem] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let overallData = String(cString: sqlite3_column_text(statement, 1))
                do {
                    let data = try JSONDecoder().decode(DictionaryItem.self, from: overallData.data(using: .utf8)!)
                    result.append(data)
                } catch {
                    print("JSONDecoder Error")
                }
            }
        } else {
            print("read Data prepare fail")
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func fetchData() {
        let query = "delete from myDB where id >= 2"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete data success")
            } else {
                print("delete data step fail")
            }
        } else {
            print("delete data prepare fail")
        }
        sqlite3_finalize(statement)
    }
    
    func updateData() {
        let query = "update myDB set id = 2 where id = 5"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("success updateData")
            } else {
                print("updataData sqlite3 step fail")
            }
        } else {
            print("updateData prepare fail")
        }
    }
}
