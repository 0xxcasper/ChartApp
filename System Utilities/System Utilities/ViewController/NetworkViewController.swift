//
//  NetworkViewController.swift
//  System Utilities
//

import Foundation

//import ChameleonFramework
import Charts

class NetworkViewController: BasePieViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var receivedLabel: UILabel!
    @IBOutlet weak var sendLabel: UILabel!
    @IBOutlet weak var cicleWifiView: UIView!
    @IBOutlet weak var cicle3GView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Header
        self.headerView.backgroundColor = UIColor(red:0.93, green:0.35, blue:0.58, alpha:1)
//            GradientColor(
//                UIGradientStyle.TopToBottom,
//                frame: CGRectMake(0, 0, ScreenSize.Width, CGFloat(self.heighHeaderView)),
//                colors: [UIColor(red:0.93, green:0.35, blue:0.58, alpha:1),
//                    UIColor(red:0.21, green:0.28, blue:0.52, alpha:1)])
        
        // Setup tableview
        let foolterView = UIView ()
        foolterView.backgroundColor = self.tableView.backgroundColor
        self.tableView.tableFooterView = foolterView
        
        // Setup cicle view
        self.cicle3GView.layer.cornerRadius = self.cicle3GView.width/2
        self.cicleWifiView.layer.cornerRadius = self.cicleWifiView.width/2
        self.cicle3GView.clipsToBounds = true
        self.cicleWifiView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Draw pie data
        self.drawData()
        
        // Draw other information
        if !(SystemValue.connectedToCellNetwork == true
            || SystemValue.connectedToWiFi == true) {
                self.titleLabel.text = "NOT CONNECT"
                self.subTitleLabel.text = "You are not connect to the internet"
                
                self.cicle3GView.backgroundColor = UIColor(red:1, green:0.23, blue:0.19, alpha:1)
                self.cicleWifiView.backgroundColor = UIColor(red:1, green:0.23, blue:0.19, alpha:1)
        }
        if SystemValue.connectedToCellNetwork == true {
            self.cicle3GView.backgroundColor   = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1)
            
            self.receivedLabel.text = self.getWWANDataReceived()
            self.sendLabel.text = self.getWWANDataSend()
        } else {
            self.cicle3GView.backgroundColor   = UIColor(red:1, green:0.23, blue:0.19, alpha:1)
        }
        
        if SystemValue.connectedToWiFi == true {
            self.cicleWifiView.backgroundColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1)
            
            self.receivedLabel.text = self.getWifiDataReceived()
            self.sendLabel.text = self.getWifiDataSend()
        } else {
            self.cicleWifiView.backgroundColor = UIColor(red:1, green:0.23, blue:0.19, alpha:1)
        }
    }
    
    private func drawData() {
        self.chartView.drawCenterTextEnabled = false
        self.chartView.rotationAngle = 90
        self.chartView.rotationEnabled = true
        
        let l:Legend = self.chartView.legend
        l.enabled = false
        self.chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanSent     =  (networkDataCounters[2] as! NSNumber).floatValue
        var wwanReceived = (networkDataCounters[3] as! NSNumber).floatValue
        // Nếu có kết nối = wifi, sử dụng dữ liệu wifi
        if SystemValue.connectedToWiFi == true {
            wwanSent     =  (networkDataCounters[0] as! NSNumber).floatValue
            wwanReceived = (networkDataCounters[1] as! NSNumber).floatValue
        }
        let wwanSentPercent = (wwanSent * 100)/(wwanSent + wwanReceived)
        
        // Set data
        let values = [Double(wwanSentPercent), Double(100 - wwanSentPercent)]
        var dataEntries: Array<BarChartDataEntry> = Array()
        for i: Int in 0...values.count - 1 {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.colors = [
            UIColor(red:0.55, green:0.68, blue:0.88, alpha:1),
            UIColor(red:0.99, green:0.75, blue:0.33, alpha:1)
        ]
        
        let data = PieChartData(dataSet: dataSet)
        self.chartView.data = data
        self.chartView.highlightValues(nil)
    }
    
    // MARK: - UITableViewDelegate & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
        self.tableView.dequeueReusableCell(withIdentifier: "NetworkTableViewCell", for: indexPath)
        as! NetworkTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text    = "MAC Address:"
            cell.subTitleLabel.text = "MAC Address:"
            break
        case 1:
            cell.titleLabel.text    = SystemValue.currentMACAddress
            cell.subTitleLabel.text = SystemValue.cellMACAddress
            break
        case 2:
            cell.titleLabel.text    = "IP Address:" + SystemValue.currentIPAddress
            if let ipAddress = SystemValue.cellIPAddress {
                cell.subTitleLabel.text = "IP Address:" + ipAddress
            } else {
                cell.subTitleLabel.text = "IP Address:"
            }
            break
        case 3:
            cell.titleLabel.text    = "Data Send:" + self.getWifiDataSend()
            cell.subTitleLabel.text = "Data Send:" + self.getWWANDataSend()
            break
        case 4:
            cell.titleLabel.text    = "Data Received:" + self.getWifiDataReceived()
            cell.subTitleLabel.text = "Data Received:" + self.getWWANDataReceived()
            break
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Network helper
    
    func getWWANDataReceived() -> String {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanReceived = (networkDataCounters[3] as! NSNumber).floatValue
        
        var receivedUnit = "KB"
        if wwanReceived > 1024 {
            wwanReceived = wwanReceived/1024
            receivedUnit = "MB"
        }
        if wwanReceived > 1024 {
            wwanReceived = wwanReceived/1024
            receivedUnit = "GB"
        }
        return String(format: "%.1f %@",wwanReceived, receivedUnit)
    }
    
    func getWWANDataSend() -> String {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanSent     =  (networkDataCounters[2] as! NSNumber).floatValue
        
        var sendUnit = "KB"
        if wwanSent > 1024 {
            wwanSent = wwanSent/1024
            sendUnit = "MB"
        }
        if wwanSent > 1024 {
            wwanSent = wwanSent/1024
            sendUnit = "GB"
        }
        return String(format: "%.1f %@",wwanSent, sendUnit)
    }
    
    func getWifiDataReceived() -> String {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanReceived = (networkDataCounters[1] as! NSNumber).floatValue
        
        var receivedUnit = "KB"
        if wwanReceived > 1024 {
            wwanReceived = wwanReceived/1024
            receivedUnit = "MB"
        }
        if wwanReceived > 1024 {
            wwanReceived = wwanReceived/1024
            receivedUnit = "GB"
        }
        return String(format: "%.1f %@",wwanReceived, receivedUnit)
    }
    
    func getWifiDataSend() -> String {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanSent     =  (networkDataCounters[0] as! NSNumber).floatValue
        
        var sendUnit = "KB"
        if wwanSent > 1024 {
            wwanSent = wwanSent/1024
            sendUnit = "MB"
        }
        if wwanSent > 1024 {
            wwanSent = wwanSent/1024
            sendUnit = "GB"
        }
        return String(format: "%.1f %@",wwanSent, sendUnit)
    }
}
