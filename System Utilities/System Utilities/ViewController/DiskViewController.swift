//
//  DiskViewController.swift
//  System Utilities
//

import Foundation
//import ChameleonFramework
import Charts
import Photos
import PhotosUI
import Darwin
import SVProgressHUD

class DiskViewController: BasePieViewController, UITableViewDelegate, UITableViewDataSource, StorageInfoControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var freeSpaceLabel: UILabel!
    @IBOutlet weak var usedSpaceLabel: UILabel!
    @IBOutlet weak var viewGradient: UIView!
    private var storageInfo: StorageInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Header
        self.headerView.backgroundColor = UIColor(red:0.23, green:0.86, blue:0.82, alpha:1)
//            GradientColor(
//                UIGradientStyle.TopToBottom,
//                frame: CGRectMake(0, 0, ScreenSize.Width, CGFloat(self.heighHeaderView)),
//                colors: [UIColor(red:0.23, green:0.86, blue:0.82, alpha:1),
//                    UIColor(red:0.54, green:0.35, blue:0.85, alpha:1)])
        
        // Setup tableview
        let foolterView = UIView()
        foolterView.backgroundColor = self.tableView.backgroundColor
        self.tableView.tableFooterView = foolterView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewGradient.setGradientBackground(colorTop: UIColor(red:0.23, green:0.86, blue:0.82, alpha:1), colorBottom: UIColor(red:0.54, green:0.35, blue:0.85, alpha:1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Draw pie data
        self.drawData()
        
        // Draw other information
        self.titleLabel.text = SSDiskInfo.diskSpace()
        self.freeSpaceLabel.text = SSDiskInfo.freeDiskSpace(false)
        self.usedSpaceLabel.text = SSDiskInfo.usedDiskSpace(false)
        
        // Get info
        SystemMonitor.storageInfoCtrl().delegate = self
        self.storageInfo = SystemMonitor.storageInfoCtrl().getStorageInfo()
        if storageInfo!.totalPictureSize != 0 {
            SVProgressHUD.show(withStatus: "updating")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status != PHAuthorizationStatus.authorized {
                    UIAlertView.show(withTitle: "Permission require",
                                     message: "Please enable photo permission access in setting", cancelButtonTitle: "Dismiss",
                                     otherButtonTitles: ["Setting"],
                                     tap: { (alertView, index) -> Void in
                        if index == 0 { UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL);
                        }
                    })
                } else {
                    // Request update info
                    self.storageInfo = SystemMonitor.storageInfoCtrl().getStorageInfo()
                }
            })
        }
    }
    
    private func drawData() {
        self.chartView.drawCenterTextEnabled = false
        self.chartView.rotationAngle = 90
        self.chartView.rotationEnabled = true
        
        let l:Legend = self.chartView.legend
        l.enabled = false
        self.chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        
        let freeDisk = Float(SSDiskInfo.longFreeDiskSpace())/1024/1024
        let fullDisk = Float(SSDiskInfo.longDiskSpace())/1024/1024
        let freeDisPercent = Float((freeDisk * 100))/fullDisk;
        
        // Set data
        let values = [Double(freeDisPercent), Double(100 - freeDisPercent)]
        var dataEntries: Array<BarChartDataEntry> = Array()
        for i: Int in 0...values.count - 1 {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.colors = [
            UIColor(red:0.37, green:0.89, blue:0.8, alpha:1),
            UIColor(red:0.55, green:0.68, blue:0.88, alpha:1)
        ]
        
        let data = PieChartData(dataSet: dataSet)
        self.chartView.data = data
        self.chartView.highlightValues(nil)
    }
    
    // MARK: - UITableViewDelegate & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
        self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Number of Songs"
            cell.detailTextLabel?.text = String(format: "%lu",self.storageInfo!.songCount)
            break
        case 1:
            cell.textLabel?.text = "Number of Pictures"
            cell.detailTextLabel?.text =
                String(format: "%lu (%@)",
                    self.storageInfo!.pictureCount,
                    AMUtils.toNearestMetric(self.storageInfo!.totalPictureSize, desiredFraction: 1))
            break
        case 2:
            cell.textLabel?.text = "Number of Videos"
            cell.detailTextLabel?.text =
                String(format: "%lu (%@)",
                    self.storageInfo!.videoCount,
                    AMUtils.toNearestMetric(self.storageInfo!.totalVideoSize, desiredFraction: 1))
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - StorageInfoControllerDelegate
    
    func storageInfoUpdated() {
        SVProgressHUD.dismiss()
        self.tableView.reloadData()
    }
}
