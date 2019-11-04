//
//  BaseDetailViewController.swift
//  System Utilities
//

import Foundation
//import ChameleonFramework
import Charts

class BasePieViewController: BaseHeaderViewController
{
    @IBOutlet weak var chartView: PieChartView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup pie
        self.setupPie()
    }        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupPie() {
        self.chartView.usePercentValuesEnabled = true
//        self.chartView.holeTransparent = true
        self.chartView.holeRadiusPercent = 0.75
        self.chartView.transparentCircleRadiusPercent = 0
//        self.chartView.descriptionText = ""
        self.chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        self.chartView.drawCenterTextEnabled = true
        self.chartView.holeColor = UIColor.clear
    }
}
