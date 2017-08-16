//
//  ViewController.swift
//  Camera
//
//  Created by manhhung on 6/27/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit
import ActionSheetPicker //support show action sheet bottom
import TesseractOCR//support recognition image text
import PEPhotoCropEditor//support crop image
import AVFoundation //support text to speech
import GrowingTextView
import SkyFloatingLabelTextField
import Toaster
import Zip



//UITextViewDelegate: Thực hiện lắng nghe sự kiện TextView
//UIImagePickerControllerDelegate, UINavigationControllerDelegate: Thực hiện truy cập camera và gallery
class ViewController: UIViewController,UINavigationControllerDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var viewContainer1: UIView!
    
    @IBOutlet weak var viewContainer2: UIView!
    
    @IBOutlet weak var edtFromOutlet: UITextView!
    
    @IBOutlet weak var edtToOutlet: UITextView!
    
    @IBOutlet weak var imgFromOutlet: UIImageView!
    @IBOutlet weak var imgToOutlet: UIImageView!
    
    @IBOutlet weak var tvFromOutlet: UILabel!
    @IBOutlet weak var tvToOutlet: UILabel!
    
    var subViewSource:UIView? = nil
    var subViewTarget:UIView? = nil
    var textViewSource:SkyFloatingLabelTextField? = nil
    var textViewTarget:UITextView? = nil
    
    
    @IBOutlet weak var viewActionTop: UIView!
    
    @IBOutlet weak var btnFrom1Outlet: UIButton!
    var positionSource = LangConstants.arrLang.index(of: settingApp.shared.getsourcename())
    var positionTarget = LangConstants.arrLang.index(of: settingApp.shared.gettargetname())
    //Show actionsheet From
    @IBAction func btnFrom1(_ sender: Any) {
        self.dismissKeyboard()
        if viewContainer1.isHidden {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewActionTop.isHidden = false
        }
        let show = ActionSheetStringPicker(title: "Languages", rows: LangConstants.arrLang, initialSelection: 0, doneBlock: { (picker, index, value) in
                if self.viewContainer1.isHidden {
                self.textViewSource?.becomeFirstResponder()
                }
                self.imgFromOutlet.image = UIImage(named: LangConstants.arrFlag[index])
                self.btnFrom1Outlet.setTitle(value as! String?, for: .normal)
                self.tvFromOutlet.text = value as! String?
                settingApp.shared.setsourceid(state: LangConstants.arrCode[index])
                settingApp.shared.setsourceimg(state: LangConstants.arrFlag[index])
                settingApp.shared.setsourcename(state: LangConstants.arrLang[index])
                self.positionSource = LangConstants.arrLang.index(of: settingApp.shared.getsourcename())
    
            
        }, cancel: { (ActionMultipleStringCancelBlock) in
            if self.viewContainer1.isHidden {
                self.textViewSource?.becomeFirstResponder()
            }
            return
        }, origin: sender)
        show?.show()
        
    }
    

    
    @IBOutlet weak var btnConvertOutlet: UIButton!
    
    @IBAction func btnConvert(_ sender: Any) {
        btnConvertOutlet.rotate360Degrees()
        let tempFlag = settingApp.shared.getsourceimg()
        settingApp.shared.setsourceimg(state: settingApp.shared.gettargetimg())
        settingApp.shared.settargetimg(state: tempFlag)
        
        let tempID = settingApp.shared.getsourceid()
        settingApp.shared.setsourceid(state: settingApp.shared.gettargetid())
        settingApp.shared.settargetid(state: tempID)
        
        let tempName = settingApp.shared.getsourcename()
        settingApp.shared.setsourcename(state: settingApp.shared.gettargetname())
        settingApp.shared.settargetname(state: tempName)
        
        setProperty()
        
        if !viewContainer1.isHidden {
            if !txtFromOutlet.text.isEmpty {
                let queue_translater = DispatchQueue(label: "queue_translater")
                queue_translater.async {
                    DispatchQueue.main.async {
                        self.txtFromOutlet.text = self.txtToOutlet.text
                        self.txtToOutlet.text =  self.translater.translater(input: self.txtFromOutlet.text)
                    }
                }
            }
        }else{
        
            if !(textViewSource?.text?.isEmpty)! {
                let queue_translater = DispatchQueue(label: "queue_translater")
                queue_translater.async {
                    DispatchQueue.main.async {
                        self.textViewSource?.text = self.textViewTarget?.text
                        self.textViewTarget?.text =  self.translater.translater(input: (self.textViewSource?.text!)!)
                    }
                }
            }
        }
        
    }
    
    
    func setProperty() {
        tvToOutlet.text = settingApp.shared.gettargetname()
        tvFromOutlet.text = settingApp.shared.getsourcename()
        btnTo1Outlet.setTitle(settingApp.shared.gettargetname(), for: .normal)
        btnFrom1Outlet.setTitle(settingApp.shared.getsourcename(), for: .normal)
        imgToOutlet.image = UIImage(named: settingApp.shared.gettargetimg())
        imgFromOutlet.image = UIImage(named: settingApp.shared.getsourceimg())
    }
    
    @IBOutlet weak var btnTo1Outlet: UIButton!
    
    let peContrller = PECropViewController()
    let picker = UIImagePickerController()
    let controller = PECropViewController.init()
    let translater = Translater()
    var isClickFirst = false
    var isTranslater = true
    var deleteButton:UIButton? = nil
    var translaterButton:UIButton? = nil
    let databaseHelper = DataBaseHelper()
    
    let reachability = Reachability()!
    var progressLabel: UILabel?
    var viewDownload:UIView?
    
    let urlDownload = URL(string: "https://www.dropbox.com/sh/pw2o2caf7h8fou5/AACrFleQjxfCVPCBtSg0eKwQa?dl=1")!

    
    
    
    var listName = "tessdata"
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//           startDownload()
        //TODO: check network
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                
            }
        }
        
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
//                Toast(text: "Can connect network!", delay: 0.3, duration: 6).show()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChange), name: ReachabilityChangedNotification, object: reachability)
        do{
            try reachability.startNotifier()
        }catch {
            print("Could not start notifier")
        }//end check network

        
        
        self.peContrller.delegate = self
        picker.delegate = self
        controller.delegate = self
        setNavigationBar()
        setImageForButton()
        
        
        //bound view
        viewContainer1.clipsToBounds = true
        viewContainer1.layer.cornerRadius = 9
        
        viewContainer2.clipsToBounds = true
        viewContainer2.layer.cornerRadius = 9
        
        tapguestureImageFromOutlet.numberOfTapsRequired = 1
        tapguestureImageFromOutlet.numberOfTouchesRequired = 1
        
        txtToOutlet.delegate = self
        txtFromOutlet.delegate = self
        btnDeleteOutlet.isHidden = true
        
        
        setupStartApp()
        
        //set up when click view any then hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        txtFromOutlet.tag = 0
        txtToOutlet.tag = 0
        textViewSource?.resignFirstResponder()
        textViewSource?.becomeFirstResponder()
    }
    static var myWord:MyWord?
    override func viewWillAppear(_ animated: Bool) {
//        setNavigationBar()
        textViewSource?.delegate = self
        textViewSource?.resignFirstResponder()
        setupStartApp()
        if ViewController.myWord != nil {
            txtFromOutlet.text = ViewController.myWord?.source
            txtToOutlet.text = ViewController.myWord?.target
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewContainer1.isHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            viewActionTop.isHidden = false
        }
        
        let lauchedBefore = UserDefaults.standard.bool(forKey: "isSecondTime")
        if lauchedBefore {
            print("Not first time!")
        } else {
            startDownload()
            print("First time, setting userDefault")
            UserDefaults.standard.set(true, forKey: "isSecondTime")
        }
    }
    
    
    //TODO: function check network
    func internetChange(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            DispatchQueue.main.async {
                self.setNavigationBar()
                //Connect wifi
                if reachability.isReachableViaWiFi {
                
                }else {//Connect Data 3G
                    
                }
            }
        }else{//Can not connect internet
            DispatchQueue.main.async {
                self.setNavigationBarCantInternet()
                Toast(text: "Please connect to the internet", delay: 0.1, duration: 5).show()
                
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func runTranslater() {
        startTimer()
    }

    var timer: Timer?
    
    func startTimer() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func loop()  {
        let queue = DispatchQueue(label: "queue")
        queue.async {
            DispatchQueue.main.async {
                
            if self.isTranslater {
                self.textViewTarget?.text = self.translater.translater(input: (self.textViewSource?.text)!)
                if (self.textViewTarget?.text.isEmpty)! {
                    self.translaterButton?.alpha = 0.3
                    self.translaterButton?.isUserInteractionEnabled = false
                }else {
                    self.translaterButton?.alpha = 1
                    self.translaterButton?.isUserInteractionEnabled = true
                }
                let range = NSMakeRange((self.textViewTarget?.text.characters.count)! - 1, 0)
                self.textViewTarget?.scrollRangeToVisible(range)
                self.stopTimer()
            }else {
                self.isTranslater = true
            }
            }

        }
//        
//        if isTranslater {
//            textViewTarget?.text = translater.translater(input: (textViewSource?.text)!)
//            if (textViewTarget?.text.isEmpty)! {
//                translaterButton?.alpha = 0.3
//                translaterButton?.isUserInteractionEnabled = false
//            }else {
//                translaterButton?.alpha = 1
//                translaterButton?.isUserInteractionEnabled = true
//            }
//            let range = NSMakeRange((textViewTarget?.text.characters.count)! - 1, 0)
//            textViewTarget?.scrollRangeToVisible(range)
//                stopTimer()
//        }else {
//            isTranslater = true
//        }
    }
    
    //function start app
    func setupStartApp() {
        btnFrom1Outlet.setTitle(settingApp.shared.getsourcename(), for: .normal)
        btnTo1Outlet.setTitle(settingApp.shared.gettargetname(), for: .normal)
        imgFromOutlet.image = UIImage(named: settingApp.shared.getsourceimg())
        imgToOutlet.image = UIImage(named: settingApp.shared.gettargetimg())
        tvFromOutlet.text = settingApp.shared.getsourcename()
        tvToOutlet.text = settingApp.shared.gettargetname()
    }
    
    @IBAction func btnTo1(_ sender: Any) {
        self.dismissKeyboard()
       showActionSheetTo(sender: sender)
    }
    
    func showActionSheetTo(sender: Any) {
        self.dismissKeyboard()
        if viewContainer1.isHidden {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewActionTop.isHidden = false
        }
        let show = ActionSheetStringPicker(title: "Languages", rows: LangConstants.arrLang, initialSelection: 0, doneBlock: { (picker, index, value) in
            if self.viewContainer1.isHidden {
                self.textViewSource?.becomeFirstResponder()
                self.viewActionTop.isHidden = false
            }
            self.imgToOutlet.image = UIImage(named: LangConstants.arrFlag[index])
            self.btnTo1Outlet.setTitle(value as! String?, for: .normal)
            self.tvToOutlet.text = value as! String?
            settingApp.shared.settargetid(state: LangConstants.arrCode[index])
            settingApp.shared.settargetimg(state: LangConstants.arrFlag[index])
            settingApp.shared.settargetname(state: LangConstants.arrLang[index])
            self.positionTarget = LangConstants.arrLang.index(of: settingApp.shared.gettargetname())
            //dich
//            print(self.translater.translater(input: self.txtFromOutlet.text))
            if !self.viewContainer1.isHidden {
                self.txtToOutlet.text = self.translater.translater(input: self.txtFromOutlet.text)
            }else {
                self.textViewTarget?.text = self.translater.translater(input: (self.textViewSource?.text!)!)
            }
        }, cancel: {
            (ActionMultipleStringCancelBlock) in
            self.textViewSource?.becomeFirstResponder()
            return
            
        }, origin: sender)
        show?.show()
        
    }
    
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBAction func btnDeleteAction(_ sender: Any) {
        edtFromOutlet.text = ""
        btnDeleteOutlet.isHidden = true
//        dismissKeyboard()
        txtToOutlet.text = ""
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        viewContainer1.isHidden = true
        viewContainer2.isHidden = true
        dismissKeyboard()
        addView()
    }
    
    func readText() {
//      let urlString = "http://www.translate.google.com/translate_tts?tl=en&q=Hello"
//        let reqURL = NSURL(fileURLWithPath: <#T##String#>)
    }
    
    @IBOutlet weak var btnSoundFromOutlet: UIButton!

    @IBAction func btnSoundFromAction(_ sender: Any) {
        print("Click button sound")

        let read = ReadText()
        read.btnPlayTapped()
        if txtFromOutlet.text.isEmpty {
            return
        }
//        textToSpeech(languageCode: settingApp.shared.getsourceid(), text: txtFromOutlet.text)
        
        
    }
    
    //TODO: text to speech with languge and string
    func textToSpeech(languageCode:String, text:String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = 0.3
        utterance.volume = 1
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        
        
    }
    
    @IBOutlet weak var btnDocumentOutlet: UIButton!
    @IBAction func btnDocumentAction(_ sender: Any) {
       showAlert(title: "Read document", message: "Please take a photo and read the text from that image!")
    }
    
    @IBOutlet weak var btnCameraOutlet: UIButton!
    @IBAction func btnCameraAction(_ sender: Any) {
        showAlertCamera()
    }
    
    //show alert action when click button camera
    func showAlertCamera() {
        let alertAction = UIAlertController(title: "Images Options", message: "", preferredStyle: .alert)
        
        //setting font and size for title and message
        let titleFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "AmericanTypewriter", size: 18)! ]
        let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
        let attributedTitle = NSMutableAttributedString(string: "Image Options", attributes: titleFont)
        let attributedMessage = NSMutableAttributedString(string: "Select an action", attributes: messageFont)
        alertAction.setValue(attributedTitle, forKey: "attributedTitle")
        alertAction.setValue(attributedMessage, forKey: "attributedMessage")
        
        
        //setting button in alertaction
        let actionCamera = UIAlertAction(title: "Pick from camera", style: .default) { (action) in
            //call function open camera
            print("Gọi hàm chụp ảnh")
            self.openCamera()
            
        }
        
//        let image1:UIImage =
//        actionCamera.setValue(image1, forKey: "image")
        
        let actiongGallery = UIAlertAction(title: "Pick from gallery", style: .default) { (action) in
            //Gọi hàm lấy ảnh từ gallery
            print("Gọi hàm lấy ảnh từ gallery")
           self.openGallery()
        
            
        }
//        let image2 = #imageLiteral(resourceName: "icon_gallery")
//        actiongGallery.setValue(image2, forKey: "image")
        
        let actionWebsite = UIAlertAction(title: "Pick from website", style: .default) { (action) in
            //Gọi hàm lấy ảnh từ đường dẫn trên trang web
            print("Gọi ham lấy ảnh từ trang web")
            self.showAlertLoadImage()
        }
//        let image3 = #imageLiteral(resourceName: "iconinternet_32")
//        actionWebsite.setValue(image3, forKey: "image")
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        
        
        //custom alert action view
        alertAction.view.tintColor = UIColor.black
        alertAction.view.backgroundColor = UIColor.white
        alertAction.view.layer.cornerRadius = 20

        
        //add button to alertaction
        alertAction.addAction(actionCamera)
        alertAction.addAction(actiongGallery)
        alertAction.addAction(actionWebsite)
        alertAction.addAction(actionCancel)
        
        //show aleraction
        present(alertAction, animated: true) { 
            
        }
    
    }
    
    
    //TODO: show alert load image from internet
    func showAlertLoadImage() {
        let alerLoadImage = UIAlertController(title: "Enter URL from web!", message: "NOTE: Some URL might not work property.", preferredStyle: .alert)
        //Textfiel to enter link image
        alerLoadImage.addTextField { (textField) in
            textField.text = "Enter URL here!"
        }
        
        let actionLoad = UIAlertAction(title: "OK", style: .default) { (action) in
            //Load image from internet and translater
            let stringURL = alerLoadImage.textFields?[0].text
           
                self.showActivityIndicator("Loading image")
                self.view.isUserInteractionEnabled = false
                let queue = DispatchQueue(label: "queue1")
                queue.async {
                    let isLoadImageFromInternet = self.loadImageFromInternet(urlString: stringURL!)
                    if isLoadImageFromInternet {
                    self.view.isUserInteractionEnabled = false//disable view when show indicator
                    DispatchQueue.main.async {
                        self.view.isUserInteractionEnabled = true //enable view
                        self.effectView.removeFromSuperview()
                        self.openEditor(imageEdit: self.imageLoadFromInter!)
                    }
                    }else{
                        self.effectView.removeFromSuperview()
                        self.view.isUserInteractionEnabled = true
                        let alertErrorURL = UIAlertController(title: "Error load image!", message: "Please check url image!", preferredStyle: .actionSheet)
                        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        
                        // Change Title With Color and Font:
                        
                        let myString  = "Error load image!"
                        var myMutableString = NSMutableAttributedString()
                        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
                        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:0,length:myString.characters.count))
                        alertErrorURL.setValue(myMutableString, forKey: "attributedTitle")
                        
                        // Change Message With Color and Font
                        
                        let message  = "Please check url image!"
                        var messageMutableString = NSMutableAttributedString()
                        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 16.0)!])
                        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location:0,length:message.characters.count))
                        alertErrorURL.setValue(messageMutableString, forKey: "attributedMessage")
                        
                        alertErrorURL.addAction(actionOK)
                        self.present(alertErrorURL, animated: true, completion: nil)
                    }
               }
            
         }
        

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //Cancel alert
        }
        
        alerLoadImage.addAction(actionLoad)
        alerLoadImage.addAction(actionCancel)
        present(alerLoadImage, animated: true, completion: nil)
    
    }
    

    
    @IBOutlet weak var btnSoundOutlet: UIButton!
    @IBAction func btnSoundAction(_ sender: Any) {
        textToSpeech(languageCode: settingApp.shared.gettargetid(), text: txtToOutlet.text)
    }
    
    @IBOutlet weak var btnCopyOutlet: UIButton!
    @IBAction func btnCopyAction(_ sender: Any) {
        if !txtToOutlet.text.isEmpty {
            UIPasteboard.general.string = txtToOutlet.text
            ToastView.appearance().backgroundColor = UIColor(red: 0, green: 127.0/255, blue: 127/255.0, alpha: 0.8)
            
            Toast(text: "The document was copied", delay: 0.3, duration: 1).show()
        }
    }
    
    @IBOutlet weak var btnShareOutlet: UIButton!
    @IBAction func btnShareAction(_ sender: Any) {
        let activityVC = UIActivityViewController.init(activityItems: [txtToOutlet.text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var txtFromOutlet: UITextView!
    @IBOutlet weak var txtToOutlet: UITextView!
    
    //Hàm set image cho button
    func settingColorIcon(btn: UIButton!, imagename: String) {
        let origImage = UIImage(named: imagename)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = UIColor.black
    }
    
    
    //tabguesture for image from
    @IBOutlet var tapguestureImageFromOutlet: UITapGestureRecognizer!
    
    @IBAction func imgFromAction(_ sender: Any) {
        print("tap image from")
    }
    
    
    // tapgesture for image to
    @IBOutlet var taphestureImageToOutlet: UITapGestureRecognizer!
    
    @IBAction func imgToAction(_ sender: Any) {
        print("Tap image to")
        
    }
    
    //set up image for button
    func setImageForButton() {
        settingColorIcon(btn: btnConvertOutlet, imagename: "icon_switch_64")
        
        settingColorIcon(btn: btnDeleteOutlet, imagename: "icon_delete_36")
       
        settingColorIcon(btn: btnDocumentOutlet, imagename: "icon_document_44")
        settingColorIcon(btn: btnCameraOutlet, imagename: "icon_camera_44")
        
        
        settingColorIcon(btn: btnSoundFromOutlet, imagename: "icon_sound_44")
        settingColorIcon(btn: btnSoundOutlet, imagename: "icon_sound_44")
        
        settingColorIcon(btn: btnCopyOutlet, imagename: "icon_copy_44")
        settingColorIcon(btn: btnShareOutlet, imagename: "icon_share_44")
        
//        imgFromOutlet.image = UIImage(named: "england")
//        imgToOutlet.image = UIImage(named: "vietnam")
        imgToOutlet.clipsToBounds = true
        imgToOutlet.layer.cornerRadius = 9
        imgFromOutlet.clipsToBounds = true
        imgFromOutlet.layer.cornerRadius = 9
    }


    
    
    func hideViewContenerShowSubView() {
        subViewTarget?.isHidden = false
        subViewSource?.isHidden = false
        viewContainer2.isHidden = true
        viewContainer1.isHidden = true
    }
    
    func hideSubViewViewShowContener() {
        subViewTarget?.isHidden = true
        subViewSource?.isHidden = true
        viewContainer2.isHidden = false
        viewContainer1.isHidden = false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Ham set background navigation bar
    func setNavigationBar() {
      
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 66.0/255.0, green: 134.0/255.0, blue: 245.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor =  UIColor(red: 0.0/255.0, green: 127.0/255.0, blue: 255.0/255.0, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

    }
    
    
    //TODO: set background navigation bar when can't connect inetrnet
    func setNavigationBarCantInternet() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 214.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor =  UIColor(red: 214.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    //function check empty edit text
    func emptyTextView(textView: UITextView) ->Bool {
        if textView.text.isEmpty || textView.text == "" {
            return true
        }
        return false
    }
    
    
    
    
    //function open camera
    func openCamera() {
        
        //check device has camera?
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            print("Có camera")
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true//Cho phép chỉnh sửa hình ảnh sau khi chụp
            self.present(picker, animated: true, completion: nil)
    
        }else{
            showAlert(title: "Camera", message: "Sory! This device has not camera.")
        }
    }
    
    //show alert when device hasn't camera
    func showAlert(title:String, message:String) {
        let alerAction = UIAlertController(title: title, message: message, preferredStyle:
        .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alerAction.addAction(actionOk)
        self.present(alerAction, animated: true, completion: nil)
    }
    
    //function open camera
    func openGallery() {
        //Check device has gallery?
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            print("truy cập gallery")
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        
        }else{
            showAlert(title: "Gallery", message: "Sorry! This device has not gallery.")
        }
    }
    
   
    //Fuction Crop image
    func openEditor(imageEdit: UIImage) {
        
        controller.image = imageEdit
        
        let image = imageEdit;
        let width = image.size.width;
        let height = image.size.height;
        var length = width
        if width > height {
            length = height
            
        }
        
        controller.imageCropRect = CGRect(x: (width - length) / 2, y: (height - length) / 2, width: length, height: length)
        let navigationController = UINavigationController(rootViewController: controller)
        
        print("run open edit")
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true, completion: nil)
    }
    
    
//Funtion show indicator
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
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

    var imageLoadFromInter:UIImage? = UIImage()
    //TODO: load image from internet
    func loadImageFromInternet(urlString:String) -> Bool {
        do{
            let url =  URL(string: urlString)
            if url != nil {
                print("URL is nil")
                let data = try? Data(contentsOf: url!)
                imageLoadFromInter = UIImage(data: data!)!
                return true
            }
        
        } catch {
            print(error.localizedDescription)
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func deleteText()  {
        if !(textViewSource?.text?.isEmpty)! {
            textViewSource?.text = ""
            textViewTarget?.text = ""
            translaterButton?.isUserInteractionEnabled = false
            translaterButton?.alpha = 0.3
        } else {
            dismissKeyboard()
            hideSubViewViewShowContener()
        }
    }
    
    func clickButtonTranslater() {
        dismissKeyboard()
        hideSubViewViewShowContener()
//        txtFromOutlet.isUserInteractionEnabled = false
        txtToOutlet.text = textViewTarget?.text
        txtFromOutlet.text = textViewSource?.text
        databaseHelper.insertMyWord(source: (textViewSource?.text)!, target: (textViewTarget?.text)!, positionSource: positionSource!, isSave: 0, positionTarget: positionTarget!)
        
    }
    
    func tapTextTarget() {
        print("Tap")

    }
    


}


extension ViewController: PECropViewControllerDelegate {
    func cropViewController(_ controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        print("crop image")
        controller.dismiss(animated: true, completion: nil)
        showActivityIndicator("Translating. Please wait!")
        view.isUserInteractionEnabled = false
        let queue = DispatchQueue(label: "queue")
        queue.async {
             self.scanImage(myImage: croppedImage)
        }
//        scanImage(myImage: croppedImage)
    }
    func cropViewControllerDidCancel(_ controller: PECropViewController!) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}




extension ViewController: UIImagePickerControllerDelegate {
    //action cancel image picker controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel camera")
        dismiss(animated: true, completion: nil)
    }
    //action choose image from image picker contrller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Choose image")
        let chosenImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        picker.dismiss(animated: true, completion: nil)
        self.openEditor(imageEdit: chosenImage)
        
    }
    
    
    
    
}


extension ViewController: G8TesseractDelegate {
    //Get text from image
    func scanImage(myImage:UIImage) {
        
        let tesseract = G8Tesseract(language: "eng+rus", configDictionary: nil, configFileNames: nil, cachesRelatedDataPath: "foo/bar", engineMode: .tesseractOnly)
        //        let tesseract = G8Tesseract(language: "eng")
        
        
        
        tesseract?.delegate = self
        
        //Cung cap 3 engine. CubeOnly, xu ly cham nhung chinh xac
        //TesseractOnly: nhanh nhung do chinh xac thap
        //TesseractCubeCombined xu ly ca 2 o muc trung binh
        tesseract?.engineMode  = .tesseractOnly
        
        tesseract?.pageSegmentationMode = .auto //Tu nhan khi thay xuong dong
        
        //Gioi han thoi gian
//        tesseract?.maximumRecognitionTime = 60
//        tesseract?.setVariableValue("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", forKey: "tessedit_char_whitelist")
//        tesseract?.setVariableValue(".,:;'?!-", forKey: "tessedit_char_blacklist")
        
        tesseract?.image = myImage.g8_blackAndWhite()
        tesseract?.recognize()
        let data:String = (tesseract?.recognizedText)!
        let dataencode = data.data(using: String.Encoding.nonLossyASCII)
        let endcodevalue = String(data: dataencode!,  encoding: String.Encoding.utf8)
        print(endcodevalue!)
        DispatchQueue.main.async {
             self.edtFromOutlet.text = tesseract?.recognizedText
            if !self.edtFromOutlet.text.isEmpty {
                self.edtToOutlet.text = self.translater.translater(input: data)
            }
             self.effectView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }

}

extension ViewController{
    
    func keyboardWillShow(notification: NSNotification) {
//        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
//                addView()
//            hideViewContenerShowSubView()
//        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                print("Run key")
//                hideSubViewViewShowContener()
//        }
    }
}

extension ViewController:UITextViewDelegate {
    
    
    //ghi đè function lắng nghe sự kiện khi text view thay đổi
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        if textView.tag == 0 {
            if emptyTextView(textView: textView) {
                btnDeleteOutlet.isHidden = true
            }else {
                btnDeleteOutlet.isHidden = false
            }
        }
      
    }
    

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        btnDeleteOutlet.isHidden = false
        if !isClickFirst {
            isClickFirst = true
            txtFromOutlet.text = ""
        }
        if textView.tag == 0 {
            print("TAG = 0")
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            viewContainer1.isHidden = true
            viewContainer2.isHidden = true
            textViewSource?.becomeFirstResponder()
        
            addView()
            if !(txtFromOutlet?.text?.isEmpty)! {
                textViewSource?.text = txtFromOutlet.text
                textViewTarget?.text = txtToOutlet.text
                translaterButton?.isUserInteractionEnabled = true
                translaterButton?.alpha = 1
            }
        }
        
    }
}

extension ViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        print("End: ")
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isTranslater = false
        runTranslater()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textViewSource?.text?.isEmpty)! {
            return false
        }
        textViewSource?.returnKeyType =  UIReturnKeyType.go
        textViewSource?.resignFirstResponder()  //if desired
        doneAction()
        return true
    }
    
    func doneAction() {
        if !(textViewSource?.text?.isEmpty)!{
            clickButtonTranslater()
        }
    }
    
}


extension ViewController {


    
    func addView() {
        
        subViewSource = UIView(frame: CGRect(x: -1, y: viewActionTop.frame.height + viewActionTop.frame.origin.y, width: view.frame.width + 2, height: viewActionTop.frame.height * 1.3))
        let myColor = UIColor.gray
        subViewSource?.layer.borderWidth = 0.5
        subViewSource?.layer.borderColor = myColor.cgColor
        subViewSource?.backgroundColor = UIColor.white
        view.addSubview(subViewSource!)
        
        textViewSource = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 0, width: (subViewSource?.frame.width)! * 8/10, height: viewActionTop.frame.height * 1.3 - 10))
        textViewSource?.placeholder = "Press to enter text"
        textViewSource?.title = ""
       
        textViewSource?.becomeFirstResponder()
        textViewSource?.font = UIFont(name: "Arial", size: 18)
        textViewSource?.textColor = UIColor.black
        textViewSource?.tintColor = UIColor.blue
        textViewSource?.selectedLineHeight = 0
        textViewSource?.lineHeight = 0
        textViewSource?.tag = 9
        subViewSource?.addSubview(textViewSource!)
        textViewSource?.delegate = self
        textViewSource?.returnKeyType = UIReturnKeyType.go
        textViewSource?.text = ""
         deleteButton = BounceButton(frame: CGRect(x: (textViewSource?.frame.origin.x)! + (textViewSource?.frame.width)! - 20, y: 0, width: 2/10 * (subViewSource?.frame.width)!, height: viewActionTop.frame.height * 1.3))
        settingColorIcon(btn: deleteButton, imagename: "icon_clear_32")
        deleteButton?.addTarget(self, action: #selector(ViewController.deleteText), for: .touchDown)
        subViewSource?.addSubview(deleteButton!)
    
        
        subViewTarget = UIView(frame: CGRect(x: -1, y:  (subViewSource?.frame.origin.y)!  + (subViewSource?.frame.height)!  , width: (subViewSource?.frame.width)! , height: (subViewSource?.frame.height)!))
        subViewTarget?.backgroundColor = UIColor.white
        view.addSubview(subViewTarget!)
        
        textViewTarget = GrowingTextView(frame: CGRect(x: 15, y: 10, width: (textViewSource?.frame.width)! , height: (textViewSource?.frame.height)!))
        textViewTarget?.layer.borderColor = UIColor.white.cgColor
        textViewTarget?.layer.borderWidth = 1
        textViewTarget?.font = UIFont(name: "Arial", size: 18)
        textViewTarget?.textColor = UIColor.blue
        textViewSource?.becomeFirstResponder()
        textViewSource?.tintColor = UIColor.blue
        UITextView.appearance().tintColor = UIColor.blue
        automaticallyAdjustsScrollViewInsets = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapTextTarget))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        textViewTarget?.addGestureRecognizer(tap)
        subViewTarget?.addSubview(textViewTarget!)
        
        translaterButton = BounceButton(frame: CGRect(x: (textViewTarget?.frame.origin.x)! + (textViewTarget?.frame.width)! - 15, y: 0, width: 2/10 * (subViewTarget?.frame.width)!, height: viewActionTop.frame.height * 1.3))
        translaterButton?.isUserInteractionEnabled = false
        settingColorIcon(btn: translaterButton, imagename: "icon_translater")
        translaterButton?.addTarget(self, action: #selector(ViewController.clickButtonTranslater), for: .touchDown)
        translaterButton?.alpha = 0.3
        subViewTarget?.addSubview(translaterButton!)
    }
    

}


extension ViewController: URLSessionTaskDelegate , URLSessionDownloadDelegate{
    
    
    func startDownload()  {
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "DownloadTessdata")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
                downloadTask = backgroundSession.downloadTask(with: urlDownload)
                downloadTask.resume()
        
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileManager = FileManager()
        let paths = Bundle.main.path(forResource: "tessdata", ofType: nil)
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        let cacheData = cachePath! + "/foo/bar"
        print(cacheData)
//        cacheData = "file://" + cacheData
        
        if !fileManager.fileExists(atPath: cacheData) {
            do{
             try fileManager.createDirectory(atPath: cacheData, withIntermediateDirectories: true, attributes: nil)
                
            }catch {
                print("Lỗi tạo caches!")
            }
        }
        let pathDic = URL.init(string: cacheData)
        
       
        let tmpPath = URL.init(string: paths!)
        
        let desPath = tmpPath?.appendingPathComponent(listName)
        let desPath1 = pathDic?.appendingPathComponent(listName)
            let des = desPath?.absoluteString
        let des1 = desPath1?.absoluteString
        let tmpPath1 = "file://" + des!
        let tmpPath2 = "file://" + des1!
        print("tmpPath1: \(tmpPath1)")
        let pathFinal = URL.init(string: tmpPath1)
        let pathFinal1 = URL.init(string: tmpPath2)
        print(pathFinal1)
        print("pathFinal\(pathFinal)")
        let destinationURLForFile = URL(fileURLWithPath: paths!)
         print("destinationURLForFile: \(destinationURLForFile)")
        
        print(location)
        if fileManager.fileExists(atPath: location.absoluteString) {
            print("Exitst")
            do{
                print("Success!")
            } catch {
                print("Error file")
            }
        }else {
            
                do{
                   print("Location: \(location)")
                    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    let tem = path + "/test"
//                    let documentDirectory = URL(fileURLWithPath: path)
                    if !fileManager.fileExists(atPath: tem) {
                        do{
                            try fileManager.createDirectory(atPath: tem, withIntermediateDirectories: true, attributes: nil)
                            
                        }catch {
                            print("Lỗi tạo tem!")
                        }
                    }
                    
                    let originPath = URL.init(string: tem)?.appendingPathComponent("/tessdata.zip")
                    if fileManager.fileExists(atPath: (originPath?.absoluteString)!) {
                       try fileManager.removeItem(at: originPath!)
                    }
                      let tem2 = "file://" + (originPath?.absoluteString)!
                    let urlTem2 = URL.init(string: tem2)
                     try fileManager.moveItem(at: location, to: urlTem2!)
                  
                    let unzipDirectory = try Zip.quickUnzipFile(originPath!) // Unzip
                    print(unzipDirectory)
                    print("Move success!")
                    try fileManager.moveItem(at: unzipDirectory, to: pathFinal1!)
                    
                   print(pathFinal1)
                    
                }catch {
                    print(error.localizedDescription)
                }
    
        }
    }
    
    func contentsOfDirectoryAtPath(path: String) -> [String]? {
        guard let paths = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil}
        return paths.map { aContent in (path as NSString).appendingPathComponent(aContent)}
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        
//        let percent = Int(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite ) * 100)
//        showActivityIndicator("Loading \(percent) %")
         showActivityIndicator("    Loading .....")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        if  error != nil {
            print(error?.localizedDescription)
        }else{
            print("Task finished !")
        }
        
        effectView.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}



