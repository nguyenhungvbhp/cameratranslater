//
//  UIViewExtensions.swift
//  CameraTranslater
//
//  Created by manhhung on 7/10/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

import UIKit

extension UIView {
    func rotate360Degrees(_ duration: CFTimeInterval = 0.25, completionDelegate: CAAnimationDelegate? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI)
        rotateAnimation.duration = duration
        
        if let delegate: CAAnimationDelegate = completionDelegate {
            rotateAnimation.delegate = delegate
            print("run rotate")
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
