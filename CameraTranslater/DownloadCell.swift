//
//  DownloadCell.swift
//  DemoDownload
//
//  Created by manhhung on 8/20/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit
import Zip
import Toaster


class DownloadCell: UITableViewCell {
    
//    let urlDownload = URL(string: "https://www.dropbox.com/sh/ljwr73h88wvfvu9/AAABkCtsdXdbEoxFfUwTWa7oa?dl=1")!
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var urlDownload: URL?
    var identifier:String?
    
//    @IBOutlet weak var lblLanguages: UILabel!
//    @IBOutlet weak var buttonDownloadOutlet: UIButton!
//    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var buttonDownloadOut: UIButton!
    @IBOutlet weak var indicatorOut: UIActivityIndicatorView!
    
    var indexRow: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func actionDownload(_ sender: UIButton) {
        print(indexRow)
        print(sender.tag)
        if indexRow == sender.tag {
            buttonDownloadOut.isHidden = true
            indicatorOut.startAnimating()
            self.startDownload()
        }
    }
 
    
    
    //Hàm set image cho button
    func settingColorIcon(btn: UIButton!, imagename: String) {
        let origImage = UIImage(named: imagename)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = UIColor.black
    }
    
    
}

    /*
     #MARK: Thực hiện download
     */
    extension DownloadCell: URLSessionTaskDelegate , URLSessionDownloadDelegate {
        
        func startDownload()  {
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: identifier!)
            backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
            
            let  request = NSMutableURLRequest(url: urlDownload!)
            request.addValue("", forHTTPHeaderField: "Accept-Encoding")
            
            downloadTask = backgroundSession.downloadTask(with: urlDownload!)
            downloadTask.resume()
            
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
                    let tem = path + "/" + identifier!
                    
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
                    print(urlZipLast?.absoluteString)
                    
                    //urlZipLast CẦN XÓA
//                    if fileManager.fileExists(atPath: (urlZip?.absoluteString)!) {
//                        try fileManager.removeItem(at: urlZip!)
//                    }
                    
                    let unzipDirectory = try Zip.quickUnzipFile(urlZip!) // trả về một đường dẫn sau khi unzip
                    print(unzipDirectory)
                    
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
                        let urlSource = URL.init(string: fileSoure)
                        try fileManager.moveItem(at: urlSub!, to: urlSource!)
                        
                    }
                    print("Move success!")
                }catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        
        //Trong quá trình download
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            
            var a = Float(totalBytesWritten)
            var b = Float(totalBytesExpectedToWrite)
          
            
            
//            print("Loading")
        }
        
        //Kết thúc download
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            
            
            downloadTask = nil
            if  error != nil {
                print(error?.localizedDescription)
                ToastView.appearance().backgroundColor = UIColor(red: 191.0/255, green: 0.0/255, blue: 0.0/255.0, alpha: 0.8)
                let textnotice = "Download fail " + lblLanguage.text!
                Toast(text: textnotice, delay: 0.3, duration: 1).show()

            }else{
                print("Task finished !")
                indicatorOut.stopAnimating()
                indicatorOut.hidesWhenStopped = true
                buttonDownloadOut.isHidden = false
                settingColorIcon(btn: buttonDownloadOut, imagename: "icon_done_32")
                print(indexRow)
                LangConstants.arrDownload[indexRow!] = true
                Unity.saveUserDefault()
                print(Unity.getUserDefault())
                buttonDownloadOut.isUserInteractionEnabled = false
                
                ToastView.appearance().backgroundColor = UIColor(red: 86.0/255, green: 170.0/255, blue: 255.0/255.0, alpha: 0.8)
                let textnotice = "Download success " + lblLanguage.text!
                Toast(text: textnotice, delay: 0.3, duration: 1).show()

                
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
    

