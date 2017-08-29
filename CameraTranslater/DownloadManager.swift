//
//  DownloadManager.swift
//  CameraTranslater
//
//  Created by manhhung on 8/25/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import Foundation
import Zip
import Toaster

class DownloadManager: NSObject, URLSessionTaskDelegate , URLSessionDownloadDelegate  {

    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!

     let dataHelper = DataBaseHelper()
    
    var myDownload: MyDownload
    
    init(myDownload: MyDownload) {
        self.myDownload = myDownload

    }
    
    
    
    func startDownload()  {
    let urlDownload = URL.init(string: myDownload.stringURL!)!
    let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: myDownload.codeLanguage!)
    backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
    
    let  request = NSMutableURLRequest(url: urlDownload)
    request.addValue("", forHTTPHeaderField: "Accept-Encoding")
    
    downloadTask = backgroundSession.downloadTask(with: urlDownload)
    downloadTask.resume()
    dataHelper.updateDownloaded(_id: myDownload._id!, goal: 2)
    SupportLanguagesViewController.listDownload = dataHelper.getAllDownload()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
     
    }
    
    
    func cancelDownload() {
        if downloadTask != nil {
            downloadTask.cancel()
        }
    }
    
    //Kết thúc download
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    let fileManager = FileManager()
    //        let paths = Bundle.main.path(forResource: "tessdata", ofType: nil)
    
    // #MARK: Tạo đường directory trên cache
    let cachePathString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
    let cacheData = cachePathString! + "/foo/bar/tessdata"
    if !fileManager.fileExists(atPath: cacheData) {
    do{
    try fileManager.createDirectory(atPath: cacheData, withIntermediateDirectories: true, attributes: nil)
    
    }catch {
    print("Lỗi tạo caches!")
    }
    }
    print(cacheData)
    let urlCache = URL.init(string: "file://" + cacheData)
    print(urlCache?.absoluteString)
    
    print(location)
    if fileManager.fileExists(atPath: location.absoluteString) {
    print("Exitst")
    }else {
    
    do{
    print("Location: \(location)")
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let tem = path + "/" + myDownload.codeLanguage!
    
    if !fileManager.fileExists(atPath: tem) {
    do{
    try fileManager.createDirectory(atPath: tem, withIntermediateDirectories: true, attributes: nil)
    }
    }
    
    //Đường dẫn lưu file zip
    let urlZip = URL.init(string: tem)?.appendingPathComponent("/thumuclucfilezip.zip")
    print(urlZip)
    if fileManager.fileExists(atPath: (urlZip?.absoluteString)!) {
    try fileManager.removeItem(at: urlZip!)
    }
    
    let stringZip = "file://" + (urlZip?.absoluteString)!
    let urlZipLast = URL.init(string: stringZip) ///aaaa
    try fileManager.moveItem(at: location, to: urlZipLast!)
    
    
    let unzipDirectory = try Zip.quickUnzipFile(urlZip!) // trả về một đường dẫn sau khi unzip
    print(unzipDirectory)
    
    print(urlZipLast?.absoluteString)
    let zipLast = cutString(string: (urlZipLast?.absoluteString)!)
    print(zipLast)
    //urlZipLast CẦN XÓA
    if fileManager.fileExists(atPath: (urlZip?.absoluteString)!) {
    try fileManager.removeItem(atPath: zipLast)
    }
    
    let stringDirectory = (unzipDirectory.absoluteString)
    let index = stringDirectory.index(stringDirectory.startIndex, offsetBy: 7)
    let parentPath = stringDirectory.substring(from: index)
    print(parentPath)
    let listStringSubPath =  getListFile(path: parentPath) //Danh sách các đường dẫn file sau khi tải về
    for subPath in listStringSubPath! {
    let urlSub = URL.init(string: subPath)
    print(urlSub)
    let fileSoure = (urlCache?.absoluteString)! + "/" +  (urlSub?.lastPathComponent)!
    print(fileSoure)
    let cutFileSource = cutString(string: fileSoure)
    print(cutFileSource)
    let urlSource = URL.init(string: fileSoure)
    if fileManager.fileExists(atPath: cutFileSource) {
    print("File exists. Remove")
    try fileManager.removeItem(atPath: cutFileSource)
    }
    try fileManager.moveItem(at: urlSub!, to: urlSource!)
    
    }
    print("Move success!")
    }catch {
    print(error.localizedDescription)
    }
    
    }
    }
    
    //Hàm cắt bỏ file://
    func cutString(string: String) -> String {
    let index = string.index(string.startIndex, offsetBy: 7)
    return string.substring(from: index)
    }
    
    
    //Trong quá trình download
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    
    }
    
    //Kết thúc download
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    
    
    downloadTask = nil
    if  error != nil {
    print(error?.localizedDescription)
//    ToastView.appearance().backgroundColor = UIColor(red: 191.0/255, green: 0.0/255, blue: 0.0/255.0, alpha: 0.8)
//    let textnotice = "Download " + myDownload.name! + " fail!"
//    Toast(text: textnotice, delay: 0.3, duration: 1).show()
//     dataHelper.updateDownloaded(_id: myDownload._id!, goal: 0)
    }else{
    print("Task finished !")
        
        
            ToastView.appearance().backgroundColor = UIColor(red: 86.0/255, green: 170.0/255, blue: 255.0/255.0, alpha: 0.8)
            let textnotice = "Download success " + self.myDownload.name!
            Toast(text: textnotice, delay: 0.3, duration: 1).show()
            self.dataHelper.updateDownloaded(_id: self.myDownload._id!, goal: 1)

        
       SupportLanguagesViewController.listDownload = dataHelper.getAllDownload()
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
    }
    
    //Hàm thực hiện đọc hết đường dẫn con trong 1 folder
    func getListFile(path: String) -> [String]?{
        let filemanager:FileManager = FileManager()
        var arrPath:[String]? = []
        let files = filemanager.enumerator(atPath: path)
        while let file = files?.nextObject() {
            arrPath?.append("file://" + path + "\(file)")
        }
    
        return arrPath
    }
    
    
    

    
}
