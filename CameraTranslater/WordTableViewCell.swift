//
//  WordTableViewCell.swift
//  CameraTranslater
//
//  Created by manhhung on 7/17/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSourceOutlet: UILabel!
    @IBOutlet weak var lblTargetOutlet: UILabel!
    
    @IBOutlet weak var imgSourceOutlet: UIImageView!
    @IBOutlet weak var imgTargetOutlet: UIImageView!
    
    var _id:Int?
    var isSave:Int?
    let dataHelper = DataBaseHelper()
    
    @IBOutlet weak var buttonOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
        print(isSave!)
        print(_id!)
        if isSave == 1 {
            buttonOutlet.setImage(UIImage(named: "un_star"), for: UIControlState.normal)
        }else {
            buttonOutlet.setImage(UIImage(named: "star"), for: UIControlState.normal)
        }
        dataHelper.updateDataBASE(isSave: isSave!, _id: _id!)
    }
    
    //Hàm set image cho button
    func settingColorIcon(btn: UIButton!, imagename: String) {
        let origImage = UIImage(named: imagename)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = UIColor.black
    }

}
