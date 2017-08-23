//
//  SupportLanguagesViewController.swift
//  DemoDownload
//
//  Created by manhhung on 8/20/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit
import TesseractOCR//support recognition image text
import Toaster

class SupportLanguagesViewController: UIViewController {
    var indextTag: Int?
    
    @IBOutlet weak var tbLanguages: UITableView!
    
    var index: Int?
    var indexRownClicked: Int?
    var isClickRow:[Bool]?
    var myImage: UIImage?
    var supportLanguage = "eng"
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    static var listDownload:[MyDownload] = []
    var databaseHelper = DataBaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if myImage != nil {
            print("Image ok")
        }else {
            print("Pass image fail!")
        }
        indexRownClicked = -1
        SupportLanguagesViewController.listDownload = databaseHelper.getAllDownload(query: "SELECT * FROM dbDownload")
        isClickRow = [Bool](repeating: false, count: SupportLanguagesViewController.listDownload.count)
        tbLanguages.delegate = self
        tbLanguages.dataSource = self
        
        
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //TODO: setting property when click cell
    func settingAgain(indexSource:Int) {
        settingApp.shared.setsourceid(state: LangConstants.arrCode[indexSource])
        settingApp.shared.setsourceimg(state: LangConstants.arrFlag[indexSource])
        settingApp.shared.setsourcename(state: LangConstants.arrLang[indexSource])
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        SupportLanguagesViewController.listDownload = []
    }
    
  
}


extension SupportLanguagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myDownload = SupportLanguagesViewController.listDownload[indexPath.row]
        let cell = tbLanguages.cellForRow(at: indexPath) as! DownloadCell
        if myDownload.isDownload == 0 {
            //Show alert notice download
            if (isClickRow?[indexPath.row])! {
                print("Đang download!")
                return
            }
          isClickRow?[indexPath.row] = true
          showAlertDownload( rowClick: indexPath.row, cell: cell)
          
           
            return
        }
        
        let indexSource = SupportLanguagesViewController.listDownload[indexPath.row].indexSetup
        settingAgain(indexSource: indexSource!)
        if myImage == nil {
            return
        }
        showActivityIndicator("Translating. Please wait!")
        supportLanguage = "eng+" +  myDownload.codeLanguage!
        scanImage(myImage: myImage!)

        
    }
}

extension SupportLanguagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SupportLanguagesViewController.listDownload.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let myDownload = SupportLanguagesViewController.listDownload[indexPath.row]
        let downloadCell = tbLanguages.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! DownloadCell
        
        if myDownload.isDownload == 1 {
            downloadCell.buttonDownloadOut.isUserInteractionEnabled = false
            downloadCell.settingColorIcon(btn: downloadCell.buttonDownloadOut, imagename: "icon_done_44")
        }else {
            downloadCell.buttonDownloadOut.isUserInteractionEnabled = true
            downloadCell.settingColorIcon(btn: downloadCell.buttonDownloadOut, imagename: "icon_download_44")
        }
        
        downloadCell.buttonDownloadOut.addTarget(Any?.self, action: #selector(yourButtonClicked), for:UIControlEvents.touchUpInside )
        downloadCell.indexRow = indexPath.row
        downloadCell.buttonDownloadOut.tag = indexPath.row
        downloadCell.lblLanguage.text = myDownload.name
        downloadCell.urlDownload = URL.init(string: myDownload.stringURL!)
        downloadCell.indicatorOut.hidesWhenStopped = true
        downloadCell.identifier = myDownload.codeLanguage
        downloadCell._id = myDownload._id
        return downloadCell
    }
    
    func yourButtonClicked()  {
         SupportLanguagesViewController.listDownload = databaseHelper.getAllDownload(query: "SELECT * FROM dbDownload")
        
    }
    
    func showAlertDownload( rowClick: Int, cell: DownloadCell)  {
         let myDownload = SupportLanguagesViewController.listDownload[rowClick]
        let alert = UIAlertController(title: myDownload.name, message: "To recognize \(myDownload.name!). Please download", preferredStyle: .alert)
        let actionDownload = UIAlertAction(title: "OK", style: .default) { (action) in
            if !Reachability.isConnectedToNetwork() {
                ToastView.appearance().backgroundColor = UIColor(red: 86.0/255, green: 170.0/255, blue: 255.0/255.0, alpha: 0.8)
                Toast(text: "Connect internet to download!", delay: 0.3, duration: 1).show()
                return
            }
            cell.indexRow = rowClick
            cell.buttonDownloadOut.tag = rowClick
            cell.lblLanguage.text = myDownload.name
            cell.urlDownload = URL.init(string: myDownload.stringURL!)
            cell.buttonDownloadOut.isHidden = true
            cell.indicatorOut.startAnimating()
            cell.identifier = myDownload.codeLanguage
            cell._id = myDownload._id
            cell.startDownload()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(actionDownload)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SupportLanguagesViewController: G8TesseractDelegate {
    //Get text from image
    func scanImage(myImage:UIImage) {
        
        let tesseract = G8Tesseract(language: supportLanguage, configDictionary: nil, configFileNames: nil, cachesRelatedDataPath: "foo/bar", engineMode: .tesseractOnly)
        //        let tesseract = G8Tesseract(language: "eng")
        
        
        
        tesseract?.delegate = self
        
        //Cung cap 3 engine. CubeOnly, xu ly cham nhung chinh xac
        //TesseractOnly: nhanh nhung do chinh xac thap
        //TesseractCubeCombined xu ly ca 2 o muc trung binh
        tesseract?.engineMode  = .tesseractOnly
        
        tesseract?.pageSegmentationMode = .auto //Tu nhan khi thay xuong dong
        
        //Gioi han thoi gian
        //tesseract?.maximumRecognitionTime = 60
        
        tesseract?.image = myImage.g8_blackAndWhite()
        tesseract?.recognize()
        let source:String = (tesseract?.recognizedText)!
        let dataencode = source.data(using: String.Encoding.nonLossyASCII)
        let endcodevalue = String(data: dataencode!,  encoding: String.Encoding.utf8)
        print(endcodevalue!)
        DispatchQueue.main.async {
            var target = ""
            if !source.isEmpty {
                let translater = Translater()
                target = translater.translater(input: source)
            }
            
            print(target)
            print(source)
            ViewController.sourceText = source
            ViewController.targetText = target
            self.effectView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

extension SupportLanguagesViewController {
    //Funtion show indicator
      func showActivityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 230, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 230, height: 46)
        effectView.layer.cornerRadius = 10
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.addSubview(activityIndicator)
        effectView.addSubview(strLabel)
        view.addSubview(effectView)
        view.isUserInteractionEnabled = false
    }

}

