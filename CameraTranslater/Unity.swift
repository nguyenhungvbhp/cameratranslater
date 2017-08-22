//
//  Unity.swift
//  DemoDownload
//
//  Created by manhhung on 8/22/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import Foundation

class Unity: NSObject {
    
    static let KEY_DOWNLOAD = "isDownload"
    
    //Phuong thuc luu arrDownload
    static func saveUserDefault(){
        let userDefault = UserDefaults.standard
        userDefault.set(LangConstants.arrDownload, forKey: KEY_DOWNLOAD)
    }
    
    //phuong thuc lay arrdownload
    static func getUserDefault() -> [Bool]{
        let userDefault = UserDefaults.standard
        let arrDownload: [Bool] =  userDefault.array(forKey: KEY_DOWNLOAD) as! [Bool]
        
        return arrDownload
    }
}
