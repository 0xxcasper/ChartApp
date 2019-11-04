//
//  BatteryViewController.swift
//  System Utilities
//

import Foundation
//import ChameleonFramework
import Charts

class BatteryViewController: BasePieViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Header
        self.headerView.backgroundColor = .blue
//            GradientColor(
//                UIGradientStyle.TopToBottom,
//                frame: CGRectMake(0, 0, ScreenSize.Width, CGFloat(self.heighHeaderView)),
//                colors: [UIColor(red:0.4, green:0.27, blue:0.74, alpha:1),
//                UIColor(red:0.51, green:0.5, blue:0.92, alpha:1)])
        
        // Setup tableview
        self.tableView.tableFooterView = UIView ()
        
        if let info = SystemMonitor.batteryInfoCtrl().getBatteryInfo() {
            self.subTitleLabel.text = String (format: "%ld mAh", info.capacity)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.drawData()        
    }        
    
    private func drawData() {
        // Draw text
        let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.center
        
        let useMemory = SystemValue.batteryLevel
        let title     = String(format: "%.0f%%", useMemory)
        
        let centerText = NSMutableAttributedString (string: title)
        centerText.setAttributes(
            [NSAttributedString.Key.font: UIFont (name: "HelveticaNeue-Bold", size: 36)!,
             NSAttributedString.Key.paragraphStyle: paragraphStyle,
             NSAttributedString.Key.foregroundColor: UIColor.white],
            range: NSMakeRange(0, title.count))

        self.chartView.centerAttributedText = centerText
        self.chartView.rotationAngle = 90
        self.chartView.rotationEnabled = true
        
        let l:Legend = self.chartView.legend
        l.enabled = false
        self.chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        
        // Set data
        var yVals1: Array<BarChartDataEntry> = Array()
        yVals1.append(BarChartDataEntry(x: Double(useMemory), y: 0))
        yVals1.append(BarChartDataEntry(x: Double(100 - useMemory), y: 1))
        
        let dataSet = PieChartDataSet (entries: yVals1, label: "Test")
        dataSet.drawValuesEnabled = false
        dataSet.colors = [UIColor(red:0.49, green:0.91, blue:0.32, alpha:1),
            UIColor(red:0.62, green:0.6, blue:0.87, alpha:1)]
        
        let data = PieChartData(dataSet: dataSet)
        self.chartView.data = data
        self.chartView.highlightValues(nil)
    }
    
    // MARK: - UITableViewDelegate & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let info = SystemMonitor.batteryInfoCtrl().getBatteryInfo() {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Battery Capacity"
                cell.detailTextLabel?.text = String(format: "%ld",info.capacity)
                break
            case 1:
                cell.textLabel?.text = "Battery Voltage"
                cell.detailTextLabel?.text = String (format: "%0.2f V", info.voltage)
                break
            case 2:
                cell.textLabel?.text = "Battery Status"
                cell.detailTextLabel?.text = info.status
                break
            case 3:
                cell.textLabel?.text = "Battery Level"
                cell.detailTextLabel?.text = String (format: "%0ld %% (%ld mAh)", info.levelPercent,
                    info.levelMAH)
                break
            default:
                break
            }
        }
        return cell
    }
}
