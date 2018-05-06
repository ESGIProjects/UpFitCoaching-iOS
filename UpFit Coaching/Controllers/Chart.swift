//
//  Chart.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Charts

class Chart: UIViewController {
	
	var lineChartView = LineChartView()
	var dates = [Date(), Date().addingTimeInterval(60 * 5)]
	var numbers = [8.0, 10.0]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		lineChartView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(lineChartView)
		
		let anchors = getAnchors()
		NSLayoutConstraint.activate([
			lineChartView.topAnchor.constraint(equalTo: anchors.top),
			lineChartView.bottomAnchor.constraint(equalTo: anchors.bottom),
			lineChartView.leadingAnchor.constraint(equalTo: anchors.leading),
			lineChartView.trailingAnchor.constraint(equalTo: anchors.trailing)
			])
		
		lineChartView.noDataText = "Nothing to display"
		
		setChart()
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
