//
//  DataBaseHelper.swift
//  CameraTranslater
//
//  Created by manhhung on 7/19/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import Foundation
import GRDB

class DataBaseHelper: NSObject {
    
    //TODO: connect database
    var dbQueue:DatabaseQueue = {

        var db:DatabaseQueue = DatabaseQueue()
        do {
            Utility.copyFile(fileName: "dbCameraTranslater.sqlite")
            db = try DatabaseQueue(path: Utility.getPathCopy(fileName: "dbCameraTranslater.sqlite"))
        }
        catch {
            print("Connect database fail!")
        }
        return db
    }()
    
    //TODO: get all list history
    func getAllHistory(query: String) -> [MyWord] {
        var listHistory = [MyWord]()
        dbQueue.inDatabase{ db in
            do {
                for row in try Row.fetchAll(db, query){
                    let myWord = MyWord()
                    myWord._id = row.value(named: "_id") as Int
                    myWord.source = row.value(named: "source") as String
                    myWord.target = row.value(named: "target") as String
                    myWord.positionSource = row.value(named: "positionSource") as Int
                    myWord.positionTarget = row.value(named: "positionTarget") as Int
                    myWord.isSave = row.value(named: "isSave") as Int
                    listHistory.append(myWord)
                }
            }
            catch {
                print("Lỗi get all")
                print(error.localizedDescription)
            }
            
        }
        return listHistory
    }
    
    //TODO: update
    func updateDataBASE(isSave:Int, _id:Int) {
        dbQueue.inDatabase{ db in
            do{
                let goal = 1 - isSave
                let stringUpdate = "UPDATE dbMyWord SET isSave = \(goal) WHERE _id = \(_id)"
                try db.execute(stringUpdate)
                
            }
            catch{
                print("Loi update row")
                print(error.localizedDescription)
            }
        }
    }
    
    
    //TODO: insert record
    func insertMyWord(source:String, target:String, positionSource:Int, isSave:Int, positionTarget:Int) {
        dbQueue.inDatabase{ db in
            do{
                try db.execute(
                    "INSERT INTO dbMyWord (source, target, positionSource, isSave, positionTarget) " +
                    "VALUES (?, ?, ?, ?, ?)",
                    arguments: [source, target, positionSource, isSave, positionTarget])
                let parisId = db.lastInsertedRowID
                print(parisId)
                
            }
            catch{
               print(error.localizedDescription)
            }
            
        }
    }
    
    //TODO: delete all history
    func deleteAllWord() {
        dbQueue.inDatabase{ db in
            do{
                try db.execute("DELETE FROM dbMyWord")
                
            }
            catch{
                print(error.localizedDescription)
            }
        }

    }
    
    
    //TODO: delete word saved
    func deleteSavae(index:Int) {
        dbQueue.inDatabase{ db in
            do{
                try db.execute("UPDATE dbMyWord SET isSave = 0")
                
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    
}
