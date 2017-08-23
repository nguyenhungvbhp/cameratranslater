//
//  HistoryViewController.swift
//  CameraTranslater
//
//  Created by manhhung on 7/4/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit
import Foundation
import SkyFloatingLabelTextField



class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentControllerOutlet: UISegmentedControl!
    
    @IBOutlet weak var myTable: UITableView!
    
    var listWord:[MyWord] = []
    var databaseHelper = DataBaseHelper()

    override func viewDidAppear(_ animated: Bool) {
        segmentControllerOutlet.selectedSegmentIndex = 0
        listWord = databaseHelper.getAllHistory(query: "SELECT * FROM dbMyWord")
        
        myTable.reloadData()
        
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listWord = databaseHelper.getAllHistory(query: "SELECT * FROM dbMyWord")
        myTable.dataSource = self
        myTable.delegate = self
        myTable.reloadData()
        print("ViewDidload")
        self.myTable.separatorStyle = .none//remove line space between cells
        self.myTable.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)

        setNavigationBar()// set prob navigationbar
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let myData = listWord.count
        return myData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! WordTableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let myWord = listWord[indexPath.row]
        cell.lblSourceOutlet.text = myWord.source
        cell.lblTargetOutlet.text = myWord.target
        let isSave = myWord.isSave
        if isSave == 1 {
            cell.buttonOutlet.setImage(UIImage(named: "star"), for: UIControlState.normal)
        }else {
            cell.buttonOutlet.setImage(UIImage(named: "un_star"), for: UIControlState.normal)
        }
        let positionSource = myWord.positionSource
        let positionTarget = myWord.positionTarget
        cell.imgSourceOutlet.image = UIImage(named: LangConstants.arrFlag[positionSource!])
        cell.imgTargetOutlet.image = UIImage(named: LangConstants.arrFlag[positionTarget!])
        cell.buttonOutlet.addTarget(Any?.self, action: #selector(yourButtonClicked), for:UIControlEvents.touchUpInside )
        cell._id = myWord._id
        cell.isSave = myWord.isSave
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 5, width: self.myTable.frame.size.width - 0, height: cell.frame.height - 10))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 4.0
//        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
//        whiteRoundedView.layer.shadowOpacity = 0.5
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        
        return cell
    }
    
    func yourButtonClicked()  {
         listWord = databaseHelper.getAllHistory(query: "SELECT * FROM dbMyWord")

    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //ACTION: Click on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexTarget = listWord[indexPath.row].positionTarget
        let indexSource = listWord[indexPath.row].positionSource
        settingAgain(indexTarget: indexTarget!, indexSource: indexSource!)
        
        ViewController.myWord = listWord[indexPath.row]
        tabBarController?.selectedIndex = 0
    }
    
    
    //TODO: choose between segment history and saved
    @IBAction func segmentControllerAction(_ sender: Any) {
        if segmentControllerOutlet.selectedSegmentIndex == 1 {
            listWord = databaseHelper.getAllHistory(query: "SELECT * FROM dbMyWord WHERE isSave = 1")
        }else{
            listWord = databaseHelper.getAllHistory(query: "SELECT * FROM dbMyWord")
        }
        
        myTable.reloadData()
    }
    
    
    //Ham set background navigation bar
    func setNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor =  UIColor(red: 0.0/255.0, green: 127.0/255.0, blue: 255.0/255.0, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blue]
        
    }
    
    
    //TODO: setting property when click cell
    func settingAgain(indexTarget: Int, indexSource:Int) {
        settingApp.shared.settargetid(state: LangConstants.arrCode[indexTarget])
        settingApp.shared.settargetimg(state: LangConstants.arrFlag[indexTarget])
        settingApp.shared.settargetname(state: LangConstants.arrLang[indexTarget])
        settingApp.shared.setsourceid(state: LangConstants.arrCode[indexSource])
        settingApp.shared.setsourceimg(state: LangConstants.arrFlag[indexSource])
        settingApp.shared.setsourcename(state: LangConstants.arrLang[indexSource])
    }
    

}
