//
//  UIView+ Extension.swift
//  Baoday
//
//  Created by Ta Phuoc Hai on 7/18/15.
//  Copyright (c) 2015 Ta Phuoc Hai. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil) {
            return image!
        }
        return UIImage()
    }
    
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
