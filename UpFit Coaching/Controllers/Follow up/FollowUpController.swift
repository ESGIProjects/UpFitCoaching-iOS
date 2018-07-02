//
//  FollowUpController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Charts

enum SortingMode {
	case all, month, year
}

class FollowUpController: UIViewController {
	
	var scrollView: UIScrollView!
	var contentView: UIView!
	var timeFilter: UISegmentedControl!
	var weightTitleLabel: UILabel!
	var weightLabel: UILabel!
	var weightChartView: LineChartView!
	var bodyTitleLabel: UILabel!
	var bodyChartView: LineChartView!
	var bodyValues: UILabel!
	var measurementsTitle: UILabel!
	var measurementsChart: LineChartView!
	var measurementsValues: UILabel!
	
	var user: User?
	var measurements = [Measurements]()
	var displayedMeasurements = [String: Measurements]()
	var sorting = SortingMode.month
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "followUpController_title".localized
		view.backgroundColor = .white
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeasurements))
		
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Reload data
		loadData(for: sorting)
		loadCharts(with: displayedMeasurements)
	}
	
	private func computeBFP(for measurement: Measurements) -> Double {
		return measurement.weight / (measurement.height/100) * (measurement.height / 100)
	}
	
	private func computeBMI(for user: User?, with measurement: Measurements, and bfp: Double) -> Double? {
		guard let user = user,
			let birthDate = user.birthDate else { return nil }
		
		let dateComponents = Calendar.current.dateComponents([.year], from: birthDate, to: measurement.date)
		guard let age = dateComponents.year else { return nil }
		
		var bmi = 1.20 * bfp
		bmi += 0.23 * Double(age)
		bmi -= 10.8 * Double(user.sex) - 5.4
		
		return bmi
	}
	
	private func loadCharts(with measurements: [String: Measurements]) {
		var weightEntries = [ChartDataEntry](),
		bfpEntries = [ChartDataEntry](), bmiEntries = [ChartDataEntry](),
		hipEntries = [ChartDataEntry](), waistEntries = [ChartDataEntry](),
		thighEntries = [ChartDataEntry](), armEntries = [ChartDataEntry]()
		
		var index = 0
		
		// Compute entries
		
		for (_, measurement) in measurements {
			let bfp = computeBFP(for: measurement)
			guard let bmi = computeBMI(for: user, with: measurement, and: bfp) else { return }
			
			weightEntries.append(ChartDataEntry(x: Double(index), y: measurement.weight))
			
			bfpEntries.append(ChartDataEntry(x: Double(index), y: bfp))
			bmiEntries.append(ChartDataEntry(x: Double(index), y: bmi))
			
			hipEntries.append(ChartDataEntry(x: Double(index), y: measurement.hipCircumference))
			waistEntries.append(ChartDataEntry(x: Double(index), y: measurement.waistCircumference))
			thighEntries.append(ChartDataEntry(x: Double(index), y: measurement.thighCircumference))
			armEntries.append(ChartDataEntry(x: Double(index), y: measurement.armCircumference))
			
			index += 1
		}
		
		// Creating data sets
		
		let weightDataSet = newDataSet(with: weightEntries)
		weightDataSet.setColor(.followUpBMILine)
		
		let bfpDataSet = newDataSet(with: bfpEntries)
		bfpDataSet.setColor(.followUpBMILine)
		
		let bmiDataSet = newDataSet(with: bmiEntries)
		bmiDataSet.setColor(.followUpBMILine)
		
		let hipDataSet = newDataSet(with: hipEntries)
		hipDataSet.setColor(.followUpBMILine)
		
		let waistDataSet = newDataSet(with: waistEntries)
		waistDataSet.setColor(.followUpBMILine)
		
		let thighDataSet = newDataSet(with: thighEntries)
		thighDataSet.setColor(.followUpBMILine)
		
		let armDataSet = newDataSet(with: armEntries)
		armDataSet.setColor(.followUpBMILine)
		
		// Set data on charts
		
		setData(on: weightChartView, with: weightDataSet)
		setData(on: bodyChartView, with: bfpDataSet, bmiDataSet)
		setData(on: measurementsChart, with: hipDataSet, waistDataSet, thighDataSet, armDataSet)
	}
	
	private func newDataSet(with entries: [ChartDataEntry]) -> LineChartDataSet {
		let dataSet = LineChartDataSet(values: entries, label: nil)
		dataSet.circleRadius = 5.0
		dataSet.drawValuesEnabled = false
		dataSet.mode = .horizontalBezier
		dataSet.axisDependency = .right
		
		return dataSet
	}
	
	private func setData(on chart: LineChartView, with dataSets: IChartDataSet...) {
		let chartData = LineChartData(dataSets: dataSets)
		chart.data = chartData
	}
	
	private func loadData(for sorting: SortingMode) {
		guard let user = user else { return }
		
		if sorting == .all {
			measurements = Database().getMeasurements(for: user).sorted { $0.date > $1.date }
			
			guard let startDate = measurements.first?.date,
				var endDate = measurements.last?.date else { return }
			
			displayedMeasurements = groupMeasurements(measurements, from: &endDate, to: startDate)
		} else {
			let startDate = Date()
			var endDate: Date
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd/MM/yyyy"
			
			if sorting == .month {
				guard let date = Calendar.current.date(byAdding: .month, value: -1, to: startDate) else { return }
				endDate = date
			} else {
				guard let date = Calendar.current.date(byAdding: .year, value: -1, to: startDate) else { return }
				endDate = date
			}
			
			// Getting the correct data
			measurements = Database().getMeasurements(for: user, from: endDate)
			displayedMeasurements = groupMeasurements(measurements, from: &endDate, to: startDate)
		}
		
		print(displayedMeasurements)
	}
	
	private func groupMeasurements(_ measurements: [Measurements], from endDate: inout Date, to startDate: Date) -> [String: Measurements] {
		var dates = [String]()
		var sortedMeasurements = [String: Measurements]()
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		
		while startDate >= endDate {
			dates.append(dateFormatter.string(from: endDate))
			endDate.addTimeInterval(60 * 60 * 24)
		}
		
		for date in dates {
			let measurementsFromDate = measurements.filter { dateFormatter.string(from: $0.date) == date }
			if let mostRecent = measurementsFromDate.sorted(by: { $0.date > $1.date }).first {
				sortedMeasurements[date] = mostRecent
			}
		}
		
		return sortedMeasurements
	}
	
	@objc func addMeasurements() {
		guard let user = user else { return }
		
		let addMeasurement = AddMeasurementsController()
		addMeasurement.client = user
		present(UINavigationController(rootViewController: addMeasurement), animated: true)
	}
}
