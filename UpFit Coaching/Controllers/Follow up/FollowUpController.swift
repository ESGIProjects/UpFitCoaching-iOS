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
	
	var lineChartView: LineChartView!
	var dates = [Date]()
	var numbers = [Double]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "followUpController_title".localized
		view.backgroundColor = .white
		
		dates = [Date(), Date().addingTimeInterval(60 * 60 * 24)]
		numbers = [8.0, 10.0]
		
		setupLayout()
		setChart()
		
		presentAlert(title: "betaFeature_alertTitle".localized, message: "betaFeature_alertMessage".localized)
	}
	
	func setChart() {
		var entries = [ChartDataEntry]()
		var strDates = [String]()
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		
		for (index, date) in dates.enumerated() {
			let entry = ChartDataEntry(x: Double(index), y: numbers[index])
			entries.append(entry)
			strDates.append(dateFormatter.string(from: date))
		}
		
		// Creating the data set
		let dataSet = LineChartDataSet(values: entries, label: "Nombres")
		dataSet.drawCirclesEnabled = false
		dataSet.colors = [.red]
		
		// Creating the data from data set
		let data = LineChartData(dataSet: dataSet)
		lineChartView.data = data
	}
}
