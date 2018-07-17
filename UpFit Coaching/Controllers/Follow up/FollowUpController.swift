//
//  FollowUpController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Charts

enum SortingMode: Int {
	case all = 0, year, month
}

class FollowUpController: UIViewController {
	
	var scrollView: UIScrollView!
	var contentView: UIView!
	var timeFilter: UISegmentedControl!
	var weightTitleLabel: UILabel!
	var weightLabel: UILabel!
	var weightChart: LineChartView!
	var bodyTitleLabel: UILabel!
	var bodyChart: LineChartView!
	var bodyValues: UILabel!
	var measurementsTitle: UILabel!
	var measurementsChart: LineChartView!
	var measurementsValues: UILabel!
	
	var user: User?
	var measurements = [Measurements]()
	var displayedMeasurements = [Measurements]()
	var dates = [String]()
	var sorting = SortingMode.month
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "followUpController_title".localized
		view.backgroundColor = .white
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeasurements))
		
		setupLayout()
		
		if user?.type == 0 || user?.type == 1 {
			NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .followUpDownloaded, object: nil)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Reload data
		reloadData()
		
		guard let measurement = measurements.first else { return }
		updateTexts(for: measurement)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: .followUpDownloaded, object: nil)
	}
	
	// MARK: - Actions
	
	@objc private func reloadData() {
		loadData(for: sorting)
		loadCharts(with: displayedMeasurements)
	}
	
	@objc func addMeasurements() {
		guard let user = user else { return }
		
		let addMeasurement = AddMeasurementsController()
		addMeasurement.client = user
		present(UINavigationController(rootViewController: addMeasurement), animated: true)
	}
	
	@objc func changeFilter() {
		guard let newSorting = SortingMode(rawValue: timeFilter.selectedSegmentIndex) else { return }
		sorting = newSorting
		
		reloadData()
	}
	
	// MARK: - Computing
	
	func computeBFP(for measurement: Measurements) -> Double {
		return measurement.weight / ((measurement.height / 100) * (measurement.height / 100))
	}
	
	func computeBMI(for user: User?, with measurement: Measurements, and bfp: Double) -> Double? {
		guard let user = user,
			let birthDate = user.birthDate else { return nil }
		
		let dateComponents = Calendar.current.dateComponents([.year], from: birthDate, to: measurement.date)
		guard let age = dateComponents.year else { return nil }
		
		var bmi = 1.20 * bfp
		bmi += 0.23 * Double(age)
		bmi -= 10.8 * Double(user.sex) - 5.4
		
		return bmi
	}
	
	// MARK: - Helpers
	
	private func updateTexts(for measurement: Measurements) {
		let numberFormatter = NumberFormatter()
		numberFormatter.alwaysShowsDecimalSeparator = false
		numberFormatter.maximumFractionDigits = 1
		
		let currentBFP = computeBFP(for: measurement)
		guard let currentBMI = computeBMI(for: user, with: measurement, and: currentBFP) else { return }
		
		// Format every numbers
		guard let weightNumber = numberFormatter.string(from: NSNumber(value: measurement.weight)),
			let bfpNumber = numberFormatter.string(from: NSNumber(value: currentBFP)),
			let bmiNumber = numberFormatter.string(from: NSNumber(value: currentBMI)),
			let hipNumber = numberFormatter.string(from: NSNumber(value: measurement.hipCircumference)),
			let waistNumber = numberFormatter.string(from: NSNumber(value: measurement.waistCircumference)),
			let thighNumber = numberFormatter.string(from: NSNumber(value: measurement.thighCircumference)),
			let armNumber = numberFormatter.string(from: NSNumber(value: measurement.armCircumference)) else { return }
		
		// Creating attributed strings
		let attributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]
		
		let bodyAttributedString = NSMutableAttributedString(string: "bfpValue".localized, attributes: attributes)
		bodyAttributedString.append(NSAttributedString(string: bfpNumber))
		bodyAttributedString.append(NSAttributedString(string: "\n"))
		bodyAttributedString.append(NSAttributedString(string: "bmiValue".localized, attributes: attributes))
		bodyAttributedString.append(NSAttributedString(string: bmiNumber))
		
		let measurementsAttributedString = NSMutableAttributedString(string: "hipValue".localized, attributes: attributes)
		measurementsAttributedString.append(NSAttributedString(string: "cm_value".localized(with: hipNumber)))
		measurementsAttributedString.append(NSAttributedString(string: "\n"))
		measurementsAttributedString.append(NSAttributedString(string: "waistValue".localized, attributes: attributes))
		measurementsAttributedString.append(NSAttributedString(string: "cm_value".localized(with: waistNumber)))
		measurementsAttributedString.append(NSAttributedString(string: "\n"))
		measurementsAttributedString.append(NSAttributedString(string: "thighValue".localized, attributes: attributes))
		measurementsAttributedString.append(NSAttributedString(string: "cm_value".localized(with: thighNumber)))
		measurementsAttributedString.append(NSAttributedString(string: "\n"))
		measurementsAttributedString.append(NSAttributedString(string: "armValue".localized, attributes: attributes))
		measurementsAttributedString.append(NSAttributedString(string: "cm_value".localized(with: armNumber)))
		
		// Set labels
		weightLabel.text = "weightValue".localized(with: weightNumber)
		bodyValues.attributedText = bodyAttributedString
		measurementsValues.attributedText = measurementsAttributedString
	}
	
	private func loadCharts(with measurements: [Measurements]) {
		if measurements.count == 0 {
			weightChart.data = nil
			bodyChart.data = nil
			measurementsChart.data = nil
			return
		}
		
		var weightEntries = [ChartDataEntry](),
		bfpEntries = [ChartDataEntry](), bmiEntries = [ChartDataEntry](),
		hipEntries = [ChartDataEntry](), waistEntries = [ChartDataEntry](),
		thighEntries = [ChartDataEntry](), armEntries = [ChartDataEntry]()
		
		var index = 0
		
		// Compute entries
		for measurement in measurements {
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
		weightDataSet.setColor(UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0))
		weightDataSet.drawFilledEnabled = true
		
		let bfpDataSet = newDataSet(with: bfpEntries, label: "bfp".localized)
		bfpDataSet.setColor(UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0))
		
		let bmiDataSet = newDataSet(with: bmiEntries, label: "bmi".localized)
		bmiDataSet.setColor(UIColor(red: 202.0/255.0, green: 10.0/255.0, blue: 170.0/255.0, alpha: 1.0))
		
		let hipDataSet = newDataSet(with: hipEntries, label: "hipCircumference".localized)
		hipDataSet.setColor(UIColor(red: 145.0/255.0, green: 39.0/255.0, blue: 243.0/255.0, alpha: 1.0))
		
		let waistDataSet = newDataSet(with: waistEntries, label: "waistCircumference".localized)
		waistDataSet.setColor(UIColor(red: 145.0/255.0, green: 241.0/255.0, blue: 90.0/255.0, alpha: 1.0))
		
		let thighDataSet = newDataSet(with: thighEntries, label: "thighCircumference".localized)
		thighDataSet.setColor(UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0))
		
		let armDataSet = newDataSet(with: armEntries, label: "armCircumference".localized)
		armDataSet.setColor(UIColor(red: 212.0/255.0, green: 128.0/255.0, blue: 0.0/255.0, alpha: 1.0))
		
		// Set data on charts
		
		setData(on: weightChart, with: weightDataSet)
		setData(on: bodyChart, with: bfpDataSet, bmiDataSet)
		setData(on: measurementsChart, with: hipDataSet, waistDataSet, thighDataSet, armDataSet)
	}
	
	private func newDataSet(with entries: [ChartDataEntry], label: String? = nil) -> LineChartDataSet {
		let dataSet = LineChartDataSet(values: entries, label: label)
		dataSet.circleRadius = 5.0
		dataSet.drawValuesEnabled = false
		dataSet.mode = .horizontalBezier
		dataSet.axisDependency = .right
		
		return dataSet
	}
	
	private func setData(on chart: LineChartView, with dataSets: IChartDataSet...) {
		let chartData = LineChartData(dataSets: dataSets)
		chart.data = chartData
		
		chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
	}
	
	private func loadData(for sorting: SortingMode) {
		guard let user = user else { return }
		
		measurements = Database().getMeasurements(for: user)
		
		if sorting == .month {
			
			let periodicMeasurements = measurements.filter {
				let now = Date()
				let currentMonth = Calendar.current.component(.month, from: now)
				let currentYear = Calendar.current.component(.year, from: now)
				
				let month = Calendar.current.component(.month, from: $0.date)
				let year = Calendar.current.component(.year, from: $0.date)
				
				return currentMonth == month && currentYear == year
			}
			
			displayedMeasurements = groupMeasurements(periodicMeasurements)
			
		} else if sorting == .year {
			let periodicMeasurements = measurements.filter {
				let now = Date()
				let currentYear = Calendar.current.component(.year, from: now)
				let year = Calendar.current.component(.year, from: $0.date)
				
				return currentYear == year
			}
			
			displayedMeasurements = groupMeasurements(periodicMeasurements)
		} else {
			displayedMeasurements = groupMeasurements(measurements)
		}
	}
	
	private func groupMeasurements(_ measurements: [Measurements]) -> [Measurements] {
		var dates = [String]()
		var sortedMeasurements = [Measurements]()
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		for measurement in measurements {
			let date = dateFormatter.string(from: measurement.date)
			if !dates.contains(date) {
				dates.append(date)
			}
		}
		dates.sort(by: <)
		
		for date in dates {
			let measurementsFromDate = measurements.filter { dateFormatter.string(from: $0.date) == date }
			if let mostRecent = measurementsFromDate.sorted(by: { $0.date > $1.date }).first {
				sortedMeasurements.append(mostRecent)
			}
		}
		
		self.dates = dates
		
		return sortedMeasurements
	}
}
