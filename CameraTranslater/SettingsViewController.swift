//
//  SettingsViewController.swift
//  Camera
//
//  Created by manhhung on 6/28/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit
import AVFoundation
import GrowingTextView
import MessageUI


class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var buttonClearSaveOutlet: UIButton!
    @IBOutlet weak var buttonClearHistoryOutlet: UIButton!
    @IBOutlet weak var buttonClearContact: UIButton!
    @IBOutlet weak var buttonContact: UIButton!
    @IBOutlet weak var buttonWebsiteOulet: UIButton!

    @IBOutlet weak var buttonRateUsOutlet: UIButton!
    
    
    var database:DataBaseHelper?

    override func viewWillAppear(_ animated: Bool) {
        setButton(button: buttonClearSaveOutlet)
        setButton(button: buttonClearHistoryOutlet)
        setButton(button: buttonClearContact)
        setButton(button: buttonContact)
        setButton(button: buttonWebsiteOulet)
        setButton(button: buttonRateUsOutlet)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = DataBaseHelper()
        
       
    }
  
    //TODO: delete all saved
    @IBAction func actionCleatAllSaved(_ sender: Any) {
        
        showActionClearWord(isRemoveAll: false)

    }
    
    //TODO: delete history
    @IBAction func actionClearAllHistory(_ sender: Any) {
        showActionClearWord(isRemoveAll: true)

    }
    
    //TODO: Contact us by email
    @IBAction func actionContactEmail(_ sender: Any) {
        let mailComposeViewController = configureMailComposeViewController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            self.showSendMailErrorAlert()
        }
    }
    
    //TODO: Show more apps on Appstore
    @IBAction func actionMoreApps(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/vn/developer/id940313516")! as URL)

    }
    
    //TODO: Show Website of company
    @IBAction func actionWebsite(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func actionRateUs(_ sender: Any) {
        rateApp { (isCheck) in
            print("Rate \(isCheck)")
        }
    }
    
    //TODO: rate app
    func rateApp(completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "https://itunes.apple.com/app/isub-learn-english-by-videos/id1233982183") else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["hungmanh.hust@gmail.com"])
        mailComposerVC.setSubject("Camera Translater")
        mailComposerVC.setMessageBody("I really satisfaction!", isHTML: false)
        return mailComposerVC
    }
    
    //TODO: Show error when send email
    func showSendMailErrorAlert() {
        let sendMailError = UIAlertView(title: "Could not send email", message: "Your device could not send e-mail", delegate: self, cancelButtonTitle: "OK")
        sendMailError.show()
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    
    }
    
    //TODO: setting button
    func setButton(button: UIButton)  {
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset =  CGSize(width: -1, height: 1)
        button.layer.cornerRadius = 5
    }
    
    func showActionClearWord(isRemoveAll:Bool) {
        
        let actionSheetOK = UIAlertAction(title: "OK", style: .destructive) { (action) in
            if isRemoveAll {
                self.database?.deleteAllWord()
            }else{
                self.database?.deleteSavae(index: 1)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
           
        }
        
        
        let alerAction = UIAlertController(title: "Detele", message: "Are you sure you want to delete?", preferredStyle:
            .alert)
        

        alerAction.addAction(actionSheetOK)
        alerAction.addAction(actionCancel)
        self.present(alerAction, animated: true, completion: nil)
        
    }
    
   }

extension SettingsViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}





