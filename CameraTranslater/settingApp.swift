//
//  settingApp.swift
//  ScannerApp
//
//  Created by tansociu on 5/26/17.
//  Copyright © 2017 tansociu. All rights reserved.
//

import Foundation

class settingApp {
    static let shared: settingApp = settingApp()
   
    init() { }
     func getPath() -> String {
        let fileManager = FileManager.default
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let path = documentDirectory.stringByAppendingString("/profile.plist")
        let path = documentDirectory.appending("/setting.plist")
        
        if(!fileManager.fileExists(atPath: path)){
            print(path)
            
            let data : [String: String] = [
                "sourcename": "English", "soureimg" : "flag_english", "sourceid": "en", "targetname" : "Vietnamese", "targetimg" : "flag_vietnam", "targetid" : "vi"]
            
            let someData = NSDictionary(dictionary: data)
            let isWritten = someData.write(toFile: path, atomically: true)
            print("is the file created: \(isWritten)")
        
            
        }else{
//            print("file exists")
        }
        return path
    }
    func getsourcename() -> String{
        let dict = getDictionary()
        let value = dict.value(forKey: "sourcename")
        return value! as! String
    }
    func setsourcename(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        
        dict?.setValue(state, forKey: "sourcename")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func getsourceimg() -> String{
        let dict = getDictionary()
        let value = dict.value(forKey: "soureimg")
        return value! as! String
    }
    func setsourceimg(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        
        dict?.setValue(state, forKey: "soureimg")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func getsourceid() -> String{
        let dict = getDictionary()
        let value = dict.value(forKey: "soureid")
        if value != nil {
            return value! as! String
        }
        else {
            return "en"
        }
        
    }
    func setsourceid(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        
        dict?.setValue(state, forKey: "soureid")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func gettargetname() -> String{
        let dict = getDictionary()
        let value = dict.value(forKey: "targetname")
        return value! as! String
    }
    func settargetname(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        
        dict?.setValue(state, forKey: "targetname")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func gettargetimg() -> String{
        let dict = getDictionary()
        let value = dict.value(forKey: "targetimg")
        return value! as! String
    }
    func settargetimg(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        
        dict?.setValue(state, forKey: "targetimg")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func gettargetid() -> String{
        let dict = getDictionary()
        let value = dict.value(forKey: "targetid")
        return value! as! String
    }
    func settargetid(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        
        dict?.setValue(state, forKey: "targetid")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func getAppPin() -> String {
        let dict = getDictionary()
        let value = dict.value(forKey: "AppPin")
        return value! as! String
    }
    func setAppPin(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        
        dict?.setValue(state, forKey: "AppPin")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func getDictionary() -> NSDictionary {
        var myDict: NSDictionary?
        let path = getPath()
        myDict = NSDictionary(contentsOfFile: path)
        return myDict!
    }
    

    func crearFilepasscode() -> String {
        let fileManager = FileManager.default
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //        let path = documentDirectory.stringByAppendingString("/profile.plist")
        let path = documentDirectory.appending("/passcode.plist")
        
        if(!fileManager.fileExists(atPath: path)){
            print(path)
            
            let data : [String: String] = [
                "Appcode": ""]
            
            let someData = NSDictionary(dictionary: data)
            let isWritten = someData.write(toFile: path, atomically: true)
            print("is the file created: \(isWritten)")
            
            
        }else{
//            print("file exists")
        }
        return path
    }
    func getDictionarycode() -> NSDictionary {
        var myDict: NSDictionary?
        let path = crearFilepasscode()
        myDict = NSDictionary(contentsOfFile: path)
        return myDict!
    }
    func checkdata(value: String) ->Bool {
        var check = false
        let dict = NSMutableDictionary(contentsOfFile: crearFilepasscode())
        let allData = dict?.allKeys
        for item in allData! {
            if value == item as! String {
                check = true
                break
            }
        }
        return check
    }
    func getpassFolder(key: String) -> [String]{
        let dict = NSMutableDictionary(contentsOfFile: crearFilepasscode())
        let value = dict?.value(forKey: key) as! [String]
        return value
    }
    func setpassFolder(state: [String], key: String) {
        let dict = NSMutableDictionary(contentsOfFile: crearFilepasscode())
        dict?.setValue(state, forKey: key)
        dict?.write(toFile: crearFilepasscode(), atomically: true)
    }
    func removePass(key: String) {
        let dict = NSMutableDictionary(contentsOfFile: crearFilepasscode())
        dict?.removeObject(forKey: key)
        dict?.write(toFile: crearFilepasscode(), atomically: true)
    }
    
    func getStartApp() -> String {
        let dict = getDictionary()
        let value = dict.value(forKey: "StartApp")
        return value as! String
    }
    func setStartApp(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        dict?.setValue(state, forKey: "StartApp")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func getEmail() -> String {
        let dict = getDictionary()
        let value = dict.value(forKey: "MyEmail")
        return value as! String
    }
    func setEmail(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        dict?.setValue(state, forKey: "MyEmail")
        dict?.write(toFile: getPath(), atomically: true)
    }
    func getQuality() -> String {
        let dict = getDictionary()
        let value = dict.value(forKey: "PictureQuality")
        return value as! String
    }
    func setQuality(state: String) {
        let dict = NSMutableDictionary(contentsOfFile: getPath())
        dict?.setValue(state, forKey: "PictureQuality")
        dict?.write(toFile: getPath(), atomically: true)
    }
    
    
    func getFAQ() -> String {
        let dict = getDictionary()
        let value = dict.value(forKey: "FAQ")
        return value as! String
    }
    
    //function get time from device
    func getCurentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let currentTime = "\(day)-" + "\(month)-" + "\(year)" + "-\(hour):\(minutes):\(second)"
        return currentTime
    }
}
