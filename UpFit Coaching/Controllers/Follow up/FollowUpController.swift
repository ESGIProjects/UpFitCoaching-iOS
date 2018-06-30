//
//  FollowUpController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Charts

class FollowUpController: UIViewController {
	
	var weightTitleLabel: UILabel!
	var weightChartView: LineChartView!
	var bodyTitleLabel: UILabel!
	var bodyChartView: LineChartView!
	var BMILabel: UILabel!
	var currentBMILabel: UILabel!
	var BFPLabel: UILabel!
	var currentBFPLabel: UILabel!
	
	var user: User?
	var weightChartData: LineChartData!
	var bodyChartData: LineChartData!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "followUpController_title".localized
		view.backgroundColor = .white
		setupLayout()
	}
	
	func generateBMI() {
		var entries = [ChartDataEntry]()
		
		entries.append(ChartDataEntry(x: 1.0, y: 19.0))
		entries.append(ChartDataEntry(x: 3.0, y: 18.2))
		entries.append(ChartDataEntry(x: 6.0, y: 18.8))
		entries.append(ChartDataEntry(x: 10.0, y: 19.1))
		
		let dataSet = LineChartDataSet(values: entries, label: "bmi_label".localized)
		dataSet.setColor(.followUpBMILine)
		dataSet.circleRadius = 5.0
		dataSet.drawValuesEnabled = false
		dataSet.mode = .horizontalBezier
		dataSet.axisDependency = .right
		
		bodyChartData.addDataSet(dataSet)
	}
	
	func generateBFP() {
		var entries = [ChartDataEntry]()
		
		entries.append(ChartDataEntry(x: 1.0, y: 22.0))
		entries.append(ChartDataEntry(x: 3.0, y: 23.3))
		entries.append(ChartDataEntry(x: 6.0, y: 21.0))
		entries.append(ChartDataEntry(x: 10.0, y: 20.3))
		
		let dataSet = LineChartDataSet(values: entries, label: "bfp_label".localized)
		dataSet.setColor(.followUpBFPLine)
		dataSet.circleRadius = 5.0
		dataSet.drawValuesEnabled = false
		dataSet.mode = .horizontalBezier
		dataSet.axisDependency = .right
		
		bodyChartData.addDataSet(dataSet)
	}
	
	func generateWeight() {
		var entries = [ChartDataEntry]()
		
		entries.append(ChartDataEntry(x: 1.0, y: 61.2))
		entries.append(ChartDataEntry(x: 3.0, y: 62.3))
		entries.append(ChartDataEntry(x: 6.0, y: 62.0))
		entries.append(ChartDataEntry(x: 10.0, y: 57.3))
		
		let dataSet = LineChartDataSet(values: entries, label: "weight_label".localized)
		dataSet.setColor(.followUpWeightLine)
		dataSet.circleRadius = 5.0
		dataSet.drawValuesEnabled = false
		dataSet.drawFilledEnabled = true
		dataSet.mode = .horizontalBezier
		dataSet.axisDependency = .right
		
		weightChartData.addDataSet(dataSet)
	}
}
