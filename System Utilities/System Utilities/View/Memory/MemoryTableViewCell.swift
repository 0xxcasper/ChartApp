//
//  MemoryCollectionViewCell.swift
//  System Utilities
//

import Foundation

class MemoryTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        self.dataView.layer.cornerRadius = 4;
        self.dataView.clipsToBounds = true
    }
}