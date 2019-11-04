//
//  GeneralViewController.swift
//  System Utilities
//

import Foundation

class GeneralViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "General info"
        
        // Show back button
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
            target: nil,
            action: nil)
        negativeSpacer.width = -15
        self.navigationItem.leftBarButtonItems = [negativeSpacer, UIBarButtonItem(customView: self.backButton)]
        
        // Setup tableView
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    
    // MARK: - UITableViewDelegate & DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell =
                    self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.section == 0 {
            let systemService = SystemServices()
            switch indexPath.row {
            case 0:
                cell.textLabel!.text    = "Owner Name"
                cell.detailTextLabel?.text = systemService.systemName
                break
            case 1:
                cell.textLabel!.text    = "Device"
                cell.detailTextLabel?.text = systemService.systemDeviceTypeNotFormatted
                break
            case 2:
                cell.textLabel!.text    = "Model"
                cell.detailTextLabel?.text = systemService.deviceModel
                break
            case 3:
                cell.textLabel!.text    = "Device OS"
                cell.detailTextLabel?.text = systemService.systemsVersion
                break
            case 4:
                cell.textLabel!.text    = "Boot Time"
                let now = NSDate (timeIntervalSince1970: Double(SystemMonitor.deviceInfo().bootTime))
                let calendar = NSCalendar.current
                let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now as Date)
                let dateString = String(format: "%04ld-%02ld-%02ld %ld:%02ld:%02ld", dateComponents.year! , dateComponents.month!, dateComponents.day!, dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
                cell.detailTextLabel?.text = dateString
                break
            case 5:
                cell.textLabel!.text    = "OS Build"
                cell.detailTextLabel?.text = SystemMonitor.deviceInfo().osBuild
                break
            case 6:
                cell.textLabel!.text    = "OS Revision"
                cell.detailTextLabel?.text = String(format: "%d", SystemMonitor.deviceInfo().osRevision)
                break
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.textLabel!.text    = "Has Siri"
                cell.detailTextLabel?.text = SystemUtilities.hasSiri() ? "YES" : "NO"
                break
            case 1:
                cell.textLabel!.text    = "Has TouchID"
                cell.detailTextLabel?.text = SystemUtilities.hasTouchID() ? "YES" : "NO"
                break
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView")
        headerView?.backgroundColor = UIColor(red:0.53, green:0.52, blue:0.94, alpha:1)
        headerView?.textLabel?.textColor = UIColor.white
        headerView?.textLabel?.text = section == 0 ? "General info" : "Hardware Info"
        return headerView
    }
}
