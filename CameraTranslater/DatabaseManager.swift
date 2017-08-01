//
//  DatabaseManager.swift
//  CameraTranslater
//
//  Created by manhhung on 7/20/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import Foundation

class DatabaseManager: NSObject {
    
    //TODO: Select
    func selectSqlite( query:String,   database:OpaquePointer)->OpaquePointer{
        var statement:OpaquePointer? = nil
        sqlite3_prepare_v2(database, query, -1, &statement, nil)
        return statement!
    }
    
    
    //TODO: query database
    func queryDatabase( sql:String,  database:OpaquePointer){
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(database, sql, nil, nil, &errMsg);
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Cau truy van bi loi!")
            return
        }
    }
    
    //TODO: Connect databae
    func connectDatabaseSqlite( dbName:String,  type:String)->OpaquePointer{
        var database:OpaquePointer? = nil
        var dbPath:String = ""
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        var defaultStorePath:NSString = ""
        let storePath : NSString = documentsPath.appendingPathComponent(dbName) as NSString
        let fileManager : FileManager = FileManager.default
        let fileCopyError:NSError? = NSError()
        dbPath = Bundle.main.path(forResource: dbName , ofType:type)!
        do {
            try fileManager.copyItem(atPath: dbPath, toPath: storePath as String)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        let result = sqlite3_open(dbPath, &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
        }else{
            print("Connect success!")
        }
        return database!
    }
    
    
    func getAllMyWord() -> [MyWord] {
        let listHistory = [MyWord]()
        
        let database:OpaquePointer = self.connectDatabaseSqlite(dbName: "dbCameraTranslater", type: "sqlite")
        let statement:OpaquePointer = selectSqlite(query: "SELECT * FROM dbMyWord", database: database)
        while sqlite3_step(statement) == SQLITE_ROW {
            let myWord = MyWord()
            let _id = Int(sqlite3_column_int(statement, 0))
//            let sourceRow = sqlite3_column_text(statement, 1)
//            let source = String(describing: sourceRow)
//            let targetRow = sqlite3_column_text(statement, 2)
//            let positionSource = Int(sqlite3_column_int(statement, 3))
//            let isSave = Int(sqlite3_column_int(statement, 4)) as Int
//            let positionTarget = Int(sqlite3_column_int(statement, 5))
//            
//            myWord._id = _id
//            myWord.source = source
//            myWord.target = source
//            myWord.positionTarget = positionTarget
//            myWord.positionSource = positionSource
//            myWord.isSave = isSave
//            print(myWord)
        print(_id)
            sqlite3_finalize(statement)
            sqlite3_close(database)

        
        }
        return listHistory
    
    }

}
