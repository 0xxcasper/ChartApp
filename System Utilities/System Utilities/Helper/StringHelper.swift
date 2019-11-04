//
//  StringHelper.swift
//  Baoday
//
//  Created by Ta Phuoc Hai on 6/16/15.
//  Copyright (c) 2015 Ta Phuoc Hai. All rights reserved.
//

import Foundation

class StringHelper {
    static func heightForView(text: String, font: UIFont, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: maxHeight))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height < maxHeight ? label.frame.height : maxHeight
    }
    
    static func widthForView(text: String, font: UIFont, height: CGFloat, maxWidth: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.width < maxWidth ? label.frame.width : maxWidth
    }
}
