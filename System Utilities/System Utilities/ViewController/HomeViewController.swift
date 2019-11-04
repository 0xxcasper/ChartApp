//
//  ViewController.swift
//  System Utilities
//

import UIKit
import Charts

enum HomeCellIndex : Int
{
    case Battery
    case Memory
    case CPU
    case Disk
    case Network
    case General
}

class HomeViewController: BaseViewController,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    // Define segue
    private var segues = ["batterySegue", "memorySegue", "cpuSegue", "diskSegue", "networkSegue", "generalSegue"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionView Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PieCollectionViewCell", for: indexPath) as! PieCollectionViewCell
        
        let grayColor = Color.GrayColor
        switch indexPath.row {
        case HomeCellIndex.Battery.rawValue:
            cell.titleLabel.text = "Battery"
            
            let useMemory = SystemValue.batteryLevel
            cell.setPieData(
                title: String(format: "%.0f%%", useMemory),
                subTitle: "Discharging",
                values: [Double(useMemory), Double(100 - useMemory)],
                colors: [UIColor(red:0.49, green:0.91, blue:0.32, alpha:1),grayColor])
            break
        case HomeCellIndex.Memory.rawValue:
            cell.titleLabel.text = "Memory"
            cell.chartView.usePercentValuesEnabled = false
            
            let active   = Double(SystemValue.activeMemoryinPercent)
            let wired    = Double(SystemValue.wiredMemoryinPercent)
            let inactive = Double(SystemValue.inactiveMemoryinPercent)
            let free     = Double(SystemValue.freeMemoryinPercent)

            let values = [active, wired, inactive, free]
            let pieColors = [
                UIColor(red:0.65, green:0.64, blue:0.99, alpha:1),
                UIColor(red:0.36, green:0.89, blue:1, alpha:1),
                UIColor(red:0.99, green:0.75, blue:0.33, alpha:1),
                UIColor(red:0.39, green:0.38, blue:0.87, alpha:1)
            ]
            
            cell.setPieData(
                title: String(format: "%.0f MB", SystemValue.freeMemoryinRaw),
                subTitle: "Free",
                values: values,
                colors: pieColors)
            break
        case HomeCellIndex.CPU.rawValue:
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CPUCollectionViewCell", for: indexPath) as! CPUCollectionViewCell
            cell.reloadData()
            return cell
        case HomeCellIndex.Disk.rawValue:
            cell.titleLabel.text = "Disk"
            
            let freeDisk = Float(SystemValue.longFreeDiskSpace)/1024/1024
            let fullDisk = Float(SystemValue.longDiskSpace)/1024/1024
            let freeDisPercent = Float((freeDisk * 100))/fullDisk;

            cell.setPieData(
                title: SSDiskInfo.freeDiskSpace(false),
                subTitle: "Free",
                values: [Double(freeDisPercent), Double(100 - freeDisPercent)],
                colors: [UIColor(red:0.37, green:0.9, blue:0.81, alpha:1),grayColor])
            break
        case HomeCellIndex.Network.rawValue:
            cell.titleLabel.text = "Network"
            var title = "No"
            if SystemValue.connectedToCellNetwork == true {
                title = "3G"
            }
            if SystemValue.connectedToWiFi == true {
                title = "Wifi"
            }
            
            let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
            var wwanSent     =  (networkDataCounters[2] as! NSNumber).intValue
            var wwanReceived = (networkDataCounters[3] as! NSNumber).intValue
            // Nếu có kết nối = wifi, sử dụng dữ liệu wifi
            if SystemValue.connectedToWiFi == true {
                wwanSent     =  (networkDataCounters[0] as! NSNumber).intValue
                wwanReceived = (networkDataCounters[1] as! NSNumber).intValue
            }
            let wwanSentPercent = (wwanSent * 100)/(wwanSent + wwanReceived)
            
            cell.setPieData(
                title: title,
                subTitle: "Internet",
                values: [Double(wwanSentPercent), Double(100 - wwanSentPercent)],
                colors: [grayColor, UIColor(red:0.99, green:0.75, blue:0.33, alpha:1)])
            break
        case HomeCellIndex.General.rawValue:
            return self.collectionView.dequeueReusableCell(withReuseIdentifier: "GeneralCollectionViewCell", for: indexPath)
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (ScreenSize.Width - 30 - 15)/2, height: (ScreenSize.Width - 30 - 15)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: self.segues[indexPath.row], sender: nil)
    }
}

