//
//  ViewController.swift
//  Camera
//
//  Created by manhhung on 6/27/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit
import ActionSheetPicker //support show action sheet bottom
import PEPhotoCropEditor//support crop image
import AVFoundation //support text to speech
import GrowingTextView
import SkyFloatingLabelTextField
import Toaster
import AVFoundation
import Foundation



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
    

    
   static var sourceText = ""
   static var targetText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: check network
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                
            }
        }
        
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {

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
        
        if !(ViewController.sourceText.isEmpty) && !(ViewController.targetText.isEmpty) {
            txtFromOutlet.text = ViewController.sourceText
            txtToOutlet.text = ViewController.targetText
        }else{
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewContainer1.isHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            viewActionTop.isHidden = false
        }
    }
    
    
    
    
    //TODO: function check network
    func internetChange(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            setNavigationBar()
            DispatchQueue.main.async {
//                self.setNavigationBar()
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
        
            if !self.viewContainer1.isHidden {
                let queue = DispatchQueue(label: "diss")
                queue.async {
                    DispatchQueue.main.sync {
                       self.txtToOutlet.text = self.translater.translater(input: self.txtFromOutlet.text)
                    }
                 
                }
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
    
    
    @IBOutlet weak var btnSoundFromOutlet: UIButton!
    var audioPlayer = AVAudioPlayer()
    @IBAction func btnSoundFromAction(_ sender: Any) {
    
        if txtFromOutlet.text.isEmpty {
            return
        }
        print(txtFromOutlet.text)
       let speak = ReadGoogle.init()
       let url =  speak.playSoundSource(txtFromOutlet.text, and: settingApp.shared.getsourceid())
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.play()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            ToastView.appearance().backgroundColor = UIColor(red: 0, green: 127.0/255, blue: 127/255.0, alpha: 0.8)
            Toast(text: "Unsupport language for pronunciation", delay: 0.3, duration: 1).show()
        }
        catch {
            print("AVAudioPlayer init failed")
        }
        
        
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
        let attributedTitle = NSMutableAttributedString(string: "Image to text", attributes: titleFont)
        let attributedMessage = NSMutableAttributedString(string: "Select an image from", attributes: messageFont)
        alertAction.setValue(attributedTitle, forKey: "attributedTitle")
        alertAction.setValue(attributedMessage, forKey: "attributedMessage")
        
        
        //setting button in alertaction
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
            //call function open camera
            print("Gọi hàm chụp ảnh")
            self.openCamera()
            
        }
        
//        let image1:UIImage =
//        actionCamera.setValue(image1, forKey: "image")
        
        let actiongGallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            //Gọi hàm lấy ảnh từ gallery
            print("Gọi hàm lấy ảnh từ gallery")
           self.openGallery()
        
            
        }
        
        let actionWebsite = UIAlertAction(title: "Image from website", style: .default) { (action) in
            //Gọi hàm lấy ảnh từ đường dẫn trên trang web
            print("Gọi ham lấy ảnh từ trang web")
            self.showAlertLoadImage()
        }
        
        let actionLanguages =  UIAlertAction(title: "Support language", style: .default) { (action) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let supportController = storyBoard.instantiateViewController(withIdentifier: "NgonNgu") as! SupportLanguagesViewController
            self.present(supportController, animated: true, completion: nil)
        }
        
        let actionDemo =  UIAlertAction(title: "Demo", style: .default) { (action) in
            //Thực hiện demo image.
            self.demoImageToText()
            
        }

        
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
        alertAction.addAction(actionLanguages)
        alertAction.addAction(actionDemo)
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
    
    func moveToSuportLanguageController(myImage: UIImage)  {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let supportController = storyBoard.instantiateViewController(withIdentifier: "NgonNgu") as! SupportLanguagesViewController
        supportController.myImage = myImage
        self.present(supportController, animated: true, completion: nil)
    }
    
 
    func demoImageToText() {
        let myImageDemo = UIImage(named: "demo")
        if UserDefaults.standard.bool(forKey: "isFirstDemo") {
             print("Write demo image")

        }else {
            print("Ahihi")
            UserDefaults.standard.set(true, forKey: "isFirstDemo")
            UserDefaults.standard.synchronize()
            UIImageWriteToSavedPhotosAlbum(myImageDemo!, nil,nil, nil)
        }
        
        ToastView.appearance().backgroundColor = UIColor(red: 0, green: 127.0/255, blue: 127/255.0, alpha: 0.8)
        Toast(text: "Use quality images that we saved in the gallery", delay: 0.1, duration: 9).show()
         self.present(picker, animated: true, completion: nil)
  
    }
    

    
    @IBOutlet weak var btnSoundOutlet: UIButton!
    @IBAction func btnSoundAction(_ sender: Any) {
        
        if txtToOutlet.text.isEmpty {
            return
        }
        let speak = ReadGoogle.init()
        let url =  speak.playSoundSource(txtToOutlet.text, and: settingApp.shared.gettargetid())
        
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.play()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            ToastView.appearance().backgroundColor = UIColor(red: 0, green: 127.0/255, blue: 127/255.0, alpha: 0.8)
            Toast(text: "Unsupport language for pronunciation", delay: 0.3, duration: 1).show()
            return
        }
        catch {
            print("AVAudioPlayer init failed")
        }
        

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
       
        settingColorIcon(btn: btnDocumentOutlet, imagename: "doc_sua")
        settingColorIcon(btn: btnCameraOutlet, imagename: "icon_camera_44")
        
        
        settingColorIcon(btn: btnSoundFromOutlet, imagename: "volume_sua")
        settingColorIcon(btn: btnSoundOutlet, imagename: "volume_sua")
        
        settingColorIcon(btn: btnCopyOutlet, imagename: "copy_sua")
        settingColorIcon(btn: btnShareOutlet, imagename: "icon_share_44")
        
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
        txtToOutlet.text = textViewTarget?.text
        txtFromOutlet.text = textViewSource?.text
        databaseHelper.insertMyWord(source: (textViewSource?.text)!, target: (textViewTarget?.text)!, positionSource: positionSource!, isSave: 0, positionTarget: positionTarget!)
        
    }
    
   

}

//Thực hiện crop ảnh và image to text
extension ViewController: PECropViewControllerDelegate {
    func cropViewController(_ controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        print("crop image")
        controller.dismiss(animated: true, completion: nil)

        //Chuyển tới chọn ngôn ngữ sau khi đã crop
         self.moveToSuportLanguageController(myImage: croppedImage)
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



extension ViewController{
    
    func keyboardWillShow(notification: NSNotification) {
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        subViewTarget?.addSubview(textViewTarget!)
        
        translaterButton = BounceButton(frame: CGRect(x: (textViewTarget?.frame.origin.x)! + (textViewTarget?.frame.width)! - 15, y: 0, width: 2/10 * (subViewTarget?.frame.width)!, height: viewActionTop.frame.height * 1.3))
        translaterButton?.isUserInteractionEnabled = false
        settingColorIcon(btn: translaterButton, imagename: "icon_translater")
        translaterButton?.addTarget(self, action: #selector(ViewController.clickButtonTranslater), for: .touchDown)
        translaterButton?.alpha = 0.3
        subViewTarget?.addSubview(translaterButton!)
    }
    

}





