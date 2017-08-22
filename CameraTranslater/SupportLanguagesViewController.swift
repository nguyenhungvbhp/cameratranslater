//
//  SupportLanguagesViewController.swift
//  DemoDownload
//
//  Created by manhhung on 8/20/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit


class SupportLanguagesViewController: UIViewController {
    var indextTag: Int?
    
    let userDefault = UserDefaults.standard
    var arrDownload:[Bool]?
    
    
    var languagesSupport: [String]?
    var urlDownload: [URL]?
    
   
    @IBOutlet weak var tbLanguages: UITableView!
    
    var index: Int?
    
    var listDownload:[MyDownload] = []
    var databaseHelper = DataBaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listDownload = databaseHelper.getAllDownload(query: "SELECT * FROM dbDownload")
        for download in listDownload {
            print(download.name)
        }
        
        arrDownload = Unity.getUserDefault()
        print(arrDownload)

        
        languagesSupport = LangConstants.nameDownload
        urlDownload = LangConstants.arrURL
    
        tbLanguages.delegate = self
        tbLanguages.dataSource = self
        
        
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
}


extension SupportLanguagesViewController: UITableViewDelegate {
    
}

extension SupportLanguagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let languages = languagesSupport {
            return LangConstants.arrURL.count
        }
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        arrDownload = Unity.getUserDefault()
        
        let downloadCell = tbLanguages.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! DownloadCell
        print(arrDownload?[indexPath.row])
        if (arrDownload?[indexPath.row])! {
            print("Hello")
            downloadCell.buttonDownloadOut.isUserInteractionEnabled = false
            downloadCell.settingColorIcon(btn: downloadCell.buttonDownloadOut, imagename: "icon_done_32")
        }else {
            downloadCell.buttonDownloadOut.isUserInteractionEnabled = true
            downloadCell.settingColorIcon(btn: downloadCell.buttonDownloadOut, imagename: "icon_download_32")
        }
        downloadCell.indexRow = indexPath.row
        downloadCell.buttonDownloadOut.tag = indexPath.row
//        print(indexPath.row)
        downloadCell.lblLanguage.text = languagesSupport?[indexPath.row]
        downloadCell.urlDownload = urlDownload?[indexPath.row]
        downloadCell.indicatorOut.hidesWhenStopped = true
        downloadCell.identifier = languagesSupport?[indexPath.row]
        return downloadCell
    }
    
    
}
