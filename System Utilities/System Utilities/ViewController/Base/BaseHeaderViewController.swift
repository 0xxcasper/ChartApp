//
//  BaseHeaderViewController.swift
//  System Utilities
//

import Foundation

//import ChameleonFramework
import Charts

class BaseHeaderViewController: BaseViewController
{
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var heightHeaderViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var heighHeaderView: CGFloat {
        get {
            let temp = Int(ScreenSize.Width * 220)
            return CGFloat(temp/320)
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.heightHeaderViewConstraint.constant = self.heighHeaderView
    }
}
