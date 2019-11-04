//
//  GeneralCollectionViewCell.swift
//  System Utilities
//

import Foundation

class GeneralCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red:0.89, green:0.88, blue:0.9, alpha:1).cgColor
    }    
    
    // MARK: - UITableViewDelegate & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Device:"
            cell.detailTextLabel?.text = SystemValue.systemDeviceTypeNotFormatted
            break
        case 1:
            cell.textLabel?.text = "Model:"
            cell.detailTextLabel?.text = SystemValue.deviceModel
            break
        case 2:
            cell.textLabel?.text = "OS:"
            cell.detailTextLabel?.text = SystemValue.systemsVersion
            break
        case 3:
            cell.textLabel?.text = "Boot at:"
            let now = NSDate(timeIntervalSince1970: Double(SystemMonitor.deviceInfo().bootTime))
            let calendar = NSCalendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now as Date)
            let dateString = String(format: "%04ld-%02ld-%02ld %ld:%02ld:%02ld", dateComponents.year!, dateComponents.month!, dateComponents.day!, dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
            cell.detailTextLabel?.text = dateString
            break
        default:
            break
        }
        
        return cell
    }
}
