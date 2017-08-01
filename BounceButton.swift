//
//  BounceButton.swift
//  CameraTranslater
//
//  Created by manhhung on 7/28/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit

class BounceButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 6, options: .allowAnimatedContent, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        super.touchesBegan(touches, with: event)
    }
    
    
//    UIView.animate(withDuration: 0.6,
//    animations: {
//    self.btnDocumentOutlet.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//    self.btnDocumentOutlet.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
//    },
//    completion: { _ in
//    UIView.animate(withDuration: 0.6) {
//    print("Done")
//    self.btnDocumentOutlet.backgroundColor = UIColor.clear
//    self.btnDocumentOutlet.transform = CGAffineTransform.identity
//    }
//    })
//    print("Animation")

}
