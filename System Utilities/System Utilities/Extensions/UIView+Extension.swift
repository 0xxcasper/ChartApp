//
//  UIView+Extension.swift
//  System Utilities
//
//  Created by admin on 05/11/2019.
//  Copyright © 2019 nhan nguyen. All rights reserved.
//

import Foundation
import UIKit

// MARK: Gradient

extension UIView {
    func linearGradientBackground(colors: [CGColor], cornerRadius: CGFloat? = nil, locations: [NSNumber]? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.61)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.39)
        gradientLayer.locations = locations
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius ?? 25
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackground(colorLeft: UIColor, colorRight: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft.cgColor, colorRight.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.3)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
