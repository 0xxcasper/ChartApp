//
//  CPUViewController.swift
//  System Utilities
//

import Foundation

//import ChameleonFramework
import Charts

class CPUViewController: BaseHeaderViewController, CPUInfoControllerDelegate {
    @IBOutlet weak var cpuUsageGLView: GLKView!
    @IBOutlet weak var userChartView: PieChartView!
    @IBOutlet weak var systemChartView: PieChartView!
    @IBOutlet weak var niceChartView: PieChartView!
    
    private var glGraph: GLLineGraph?
    private var userColor = UIColor(red:0.34, green:0.89, blue:0.79, alpha:1)
    private var systemColor = UIColor(red:0.61, green:0.62, blue:0.98, alpha:1)
    private var niceColor = UIColor(red:0.99, green:0.75, blue:0.33, alpha:1)
    
    override var heighHeaderView: CGFloat {
        get {
            let temp = Int(ScreenSize.Width * 280)
            return CGFloat(temp/320)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Header
        self.headerView.backgroundColor = UIColor(red:0.45, green:0.44, blue:0.87, alpha:1)
//            GradientColor(
//                UIGradientStyle.TopToBottom,
//                frame: CGRectMake(0, 0, ScreenSize.Width, CGFloat(self.heighHeaderView)),
//                colors: [UIColor(red:0.45, green:0.44, blue:0.87, alpha:1),
//                    UIColor(red:0.38, green:0.67, blue:0.69, alpha:1)])
        
        // Setup draw
        self.cpuUsageGLView?.isOpaque = false
        self.cpuUsageGLView?.backgroundColor = UIColor.clear
        self.glGraph = GLLineGraph (
            glkView: self.cpuUsageGLView,
            dataLineCount: 1,
            fromValue: 0,
            toValue: 100,
            topLegend: "100%")
        self.glGraph!.setDataLineLegendPostfix("%")
        self.glGraph!.preferredFramesPerSecond = 2
        SystemMonitor.cpuInfoCtrl().setCPULoadHistorySize((self.glGraph?.requiredElementToFill())!)
        
        // CPU Info
        let cpuInfo: CPUInfo = SystemMonitor.cpuInfoCtrl().getCPUInfo()
        self.titleLabel.text = String (format: "Total running Processes: %d", cpuInfo.activeCPUCount)
        
        // Setup chart view
        self.setupChartView(chartView: self.userChartView)
        self.setupChartView(chartView: self.systemChartView)
        self.setupChartView(chartView: self.niceChartView)
        
        self.userChartView.backgroundColor = UIColor.white
        self.systemChartView.backgroundColor = UIColor.white
        self.niceChartView.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Lấy lịch sử cpu
        guard let cpuLoadArray = SystemMonitor.cpuInfoCtrl().cpuLoadHistory else { return }
        let graphData = NSMutableArray (capacity: cpuLoadArray.count)
        var avr:Double = 0
        
        var userAvr:Double = 0
        var systemAvr:Double = 0
        var niceAvr:Double = 0
        
        if cpuLoadArray.count > 0 {
            for i in 0...cpuLoadArray.count - 1 {
                let data: NSArray = cpuLoadArray[i] as! NSArray
                avr = 0
                userAvr = 0
                systemAvr = 0
                niceAvr = 0
                
                for j in 0...data.count - 1 {
                    let load: CPULoad = data[j] as! CPULoad
                    avr += load.total
                    userAvr += load.user
                    systemAvr += load.system
                    niceAvr += load.nice
                }
                
                avr /= Double(data.count)
                userAvr /= Double(data.count)
                systemAvr /= Double(data.count)
                niceAvr /= Double(data.count)
                
                graphData.add([(avr)])
            }
        }
        
        // Draw cpu
        self.glGraph?.resetDataArray(graphData as [AnyObject])
        SystemMonitor.cpuInfoCtrl().delegate = self
        
        // Draw chart view
        self.drawChartView(chartView: self.userChartView, value: userAvr, color: self.userColor)
        self.drawChartView(chartView: self.systemChartView, value: systemAvr, color: self.systemColor)
        self.drawChartView(chartView: self.niceChartView, value: niceAvr, color: self.niceColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        SystemMonitor.cpuInfoCtrl().delegate = nil
    }
    
    // MARK: - CPUInfoControllerDelegate
    
    func cpuLoadUpdated(_ loadArray: [Any]!) {
        var avr: Float = 0
        var userAvr:Float = 0
        var systemAvr:Float = 0
        var niceAvr:Float = 0
        
        for load in loadArray {
            avr += Float((load as AnyObject).total)
            userAvr += Float((load as AnyObject).user)
            systemAvr += Float((load as AnyObject).system)
            niceAvr += Float((load as AnyObject).nice)
        }
        avr /= Float(loadArray.count)
        userAvr /= Float(loadArray.count)
        systemAvr /= Float(loadArray.count)
        niceAvr /= Float(loadArray.count)
        
        // Update graphic
        self.glGraph!.addDataValue([(avr)])
        self.subTitleLabel.text = String(format: "Total CPU uses %.0f %%", avr)
        self.cpuUsageGLView.display()
        
        // Draw chart view
        self.drawChartView(chartView: self.userChartView, value: Double(userAvr), color: self.userColor)
        self.drawChartView(chartView: self.systemChartView, value: Double(systemAvr), color: self.systemColor)
        self.drawChartView(chartView: self.niceChartView, value: Double(niceAvr), color: self.niceColor)
        
        NSLog("value = %.1f - %0.1f - %0.1f", Float(userAvr), Float(systemAvr), Float(niceAvr))
    }
    
    // MARK: - Helper
    
    private func setupChartView(chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
//        chartView.holeTransparent = true
        chartView.holeRadiusPercent = 0.85
        chartView.transparentCircleRadiusPercent = 0
//        chartView.descriptionText = ""
        chartView.setExtraOffsets(left: -20, top: -20, right: -20, bottom: -20)
        chartView.drawCenterTextEnabled = true
        chartView.holeColor = UIColor.clear
    }
    
    private func drawChartView(chartView: PieChartView, value: Double, color: UIColor) {
        // Draw text
        let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.center
        
        let title = String (format: "%.0f", Float(value))
        
        let centerText = NSMutableAttributedString (string: title)
        centerText.setAttributes(
            [NSAttributedString.Key.font: UIFont (name: "HelveticaNeue-Bold", size: 18)!,
             NSAttributedString.Key.paragraphStyle: paragraphStyle,
             NSAttributedString.Key.foregroundColor: color],
            range: NSMakeRange(0, title.count))
        chartView.centerAttributedText = centerText
        chartView.rotationAngle = 90
        chartView.rotationEnabled = true
        
        let l:Legend = chartView.legend
        l.enabled = false
        
        // Set data
        var yVals1: Array<BarChartDataEntry> = Array()
        yVals1.append(BarChartDataEntry(x: value, y: 0))
        yVals1.append(BarChartDataEntry(x: 100 - value, y: 1))
        
        let dataSet = PieChartDataSet (entries: yVals1, label: "Test")
        dataSet.drawValuesEnabled = false
        dataSet.colors = [color, UIColor(red:0.88, green:0.88, blue:0.89, alpha:1)]
        
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data
        chartView.highlightValues(nil)
    }
}
