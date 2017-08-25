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
    
    var indexRow: Int?
    let dataHelper = DataBaseHelper()
    

    
    
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var buttonDownloadOut: UIButton!
    @IBOutlet weak var indicatorOut: UIActivityIndicatorView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func actionDownload(_ sender: UIButton) {
        print(sender.tag)
        if !Reachability.isConnectedToNetwork() {
            ToastView.appearance().backgroundColor = UIColor(red: 86.0/255, green: 170.0/255, blue: 255.0/255.0, alpha: 0.8)
            Toast(text: "Connect internet to download!", delay: 0.3, duration: 1).show()
            return
        }
        let myDownload = SupportLanguagesViewController.listDownload[indexRow!]
        print(myDownload.name)
        let downloadManager = DownloadManager(myDownload: myDownload)
        downloadManager.startDownload()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
    
    
    //Hàm set image cho button
    func settingColorIcon(btn: UIButton!, imagename: String) {
        let origImage = UIImage(named: imagename)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = UIColor.black
    }
    
    func settingColorIconDone(btn: UIButton!, imagename: String) {
        let origImage = UIImage(named: imagename)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        let colorDone = UIColor(red: 0, green: 127.0/255.0, blue: 1.0, alpha: 1)
        btn.tintColor = colorDone
    }
    
}


