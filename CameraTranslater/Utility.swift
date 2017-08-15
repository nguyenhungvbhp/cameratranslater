//
//  Utility.swift
//  CameraTranslater
//
//  Created by manhhung on 7/21/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import Foundation

class Utility :NSObject{
    
    //TODO: get path for specified file
     class func getPathCopy(fileName:String) -> String {
    
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
    
    
    //TODO: copy file from source to destination (đích đến)
    class func copyFile(fileName:String) {
        let dbPath:String = getPathCopy(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL?.appendingPathComponent(fileName)
            do{
                try fileManager.copyItem(atPath: (fromPath?.path)!, toPath: dbPath)
                print("Copy success!")
        
            }catch {
               print("Copy fail! : \(error.localizedDescription)")
            }
            
        }
    }
    
    
   class func pathToLanguageFile() -> String {
        let documents = NSSearchPathForDirectoriesInDomains(.documentationDirectory, .userDomainMask, true)
    let document = documents.first
    let dataPath = document?.appending("/tessdata")
//    print(dataPath)
    copyFile(fileName: "tessdata")
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: dataPath!) {
        let bundlePath = Bundle.main.bundlePath
        let tessdataPath = bundlePath.appending("/tessdata")
        print(tessdataPath)
        if !tessdataPath.isEmpty{
            do{
                print("Copy tessdata")
                fileManager.createFile(atPath: dataPath!, contents: nil, attributes: nil)
           try  fileManager.copyItem(atPath: tessdataPath, toPath: dataPath!)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    print(dataPath!)
    return dataPath!
    }
    
    
    
    class func downloadTessData() {
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent("/CameraTranslater/tessdata")
        print(destinationFileUrl.absoluteString)
        let des = destinationFileUrl.absoluteString.replacingOccurrences(of: "file://", with: "")
        print(des)
        //Create URL to the source file you want to download
        let fileURL = URL(string: "https://www.dropbox.com/s/fkm6f2uj0y5jn8t/vie.traineddata?dl=1")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: destinationFileUrl.path) {
                    do {
                        try fileManager.removeItem(atPath: destinationFileUrl.path)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                    
                } else {
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                }
                
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
        
    }
    
    
   
}
