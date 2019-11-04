//
//  MemoryViewController.swift
//  System Utilities
//

import Foundation
//import ChameleonFramework
import Charts

class MemoryViewController: BasePieViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var freeMemoryLabel: UILabel!
    @IBOutlet weak var usedMemoryLabel: UILabel!
    
    let pieColors = [
        UIColor(red:0.65, green:0.64, blue:0.99, alpha:1),
        UIColor(red:0.36, green:0.89, blue:1, alpha:1),
        UIColor(red:0.99, green:0.75, blue:0.33, alpha:1),
        UIColor(red:0.39, green:0.38, blue:0.87, alpha:1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Header
        self.headerView.backgroundColor = .blue
//            GradientColor(
//                UIGradientStyle.TopToBottom,
//                frame: CGRectMake(0, 0, ScreenSize.Width, CGFloat(self.heighHeaderView)),
//                colors: [UIColor(red:0.53, green:0.44, blue:0.76, alpha:1),
//                    UIColor(red:0.21, green:0.28, blue:0.52, alpha:1)])
        
        // Setup tableview
        let foolterView = UIView ()
        foolterView.backgroundColor = self.tableView.backgroundColor
        self.tableView.tableFooterView = foolterView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Draw pie data
        self.drawData()
        
        // Draw other information
        self.titleLabel.text = String (format: "(±)%.2f MB", SystemValue.totalMemory)
        self.freeMemoryLabel.text = String (format: "%.0f MB",SystemValue.freeMemoryinRaw)
        self.usedMemoryLabel.text = String (format: "%.0f MB",SystemValue.usedMemoryinRaw)
    }
    
    private func drawData() {
        self.chartView.usePercentValuesEnabled = true
        self.chartView.drawCenterTextEnabled = false
        self.chartView.rotationAngle = 90
        self.chartView.rotationEnabled = true
        
        let l:Legend = self.chartView.legend
        l.enabled = false
        self.chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        
        let active   = SystemValue.activeMemoryinPercent
        let wired    = SystemValue.wiredMemoryinPercent
        let inactive = SystemValue.inactiveMemoryinPercent
        let free     = SystemValue.freeMemoryinPercent
        
        // Set data
        var yVals1: Array<BarChartDataEntry> = Array()
        yVals1.append(BarChartDataEntry(x: Double(active), y: 0))
        yVals1.append(BarChartDataEntry(x: Double(wired), y: 1))
        yVals1.append(BarChartDataEntry(x: Double(inactive), y: 2))
        yVals1.append(BarChartDataEntry(x: Double(free), y: 3))
        
        let dataSet = PieChartDataSet(entries: yVals1, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.colors = self.pieColors
        
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MemoryTableViewCell", for: indexPath) as! MemoryTableViewCell
        cell.dataView.backgroundColor = self.pieColors[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Active"
            cell.valueLabel.text    = String (format: "%.1f%%",SystemValue.activeMemoryinPercent)
            cell.subTitleLabel.text = String (format: "%.0f MB",SystemValue.activeMemoryinRaw)
            break
        case 1:
            cell.titleLabel.text = "Wired"
            cell.valueLabel.text    = String (format: "%.1f%%",SystemValue.wiredMemoryinPercent)
            cell.subTitleLabel.text = String (format: "%.0f MB",SystemValue.wiredMemoryinRaw)
            break
        case 2:
            cell.titleLabel.text = "Inactive"
            cell.valueLabel.text    = String (format: "%.1f%%",SystemValue.inactiveMemoryinPercent)
            cell.subTitleLabel.text = String (format: "%.0f MB",SystemValue.inactiveMemoryinRaw)
            break
        case 3:
            cell.titleLabel.text = "Free"
            cell.valueLabel.text    = String (format: "%.1f%%",SystemValue.freeMemoryinPercent)
            cell.subTitleLabel.text = String (format: "%.0f MB",SystemValue.freeMemoryinRaw)
            break
        default:
            break
        }
        return cell
    }
}
