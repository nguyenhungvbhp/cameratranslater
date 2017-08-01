//
//  Translater.swift
//  CameraTranslater
//
//  Created by manhhung on 7/6/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import Foundation
import SwiftyJSON

class Translater {
    
    func translater(input:String) -> String {
        
        var output: String?
        let ouputcode = settingApp.shared.getsourceid()
        let inputcode = settingApp.shared.gettargetid()
        let source = input
        let sourcecode = "&tl="
        let descode = "&sl="
        let query = "&q="
        let url = "https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&dt=bd&dj=1&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=at"
        let urlencoding = url + sourcecode + inputcode + descode + ouputcode + query + source
        print(urlencoding)
        let stringencoding = urlencoding.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        do {
            let urlparse = URL(string: stringencoding!)
            let data = try Data(contentsOf: urlparse!, options: .alwaysMapped)
    
            let swiftyJsonVar = JSON(data)
            print(swiftyJsonVar)
            let value = swiftyJsonVar["sentences"].arrayValue.map({$0["trans"].stringValue})
            print(value)
            for element in value {
                if output == nil {
                    output = element
                } else {
                    output = output! + element
                }
            }
        } catch {
            print(error)
        }
        if output == nil {
            return input
        } else {
            return output!
        }
    }
}
