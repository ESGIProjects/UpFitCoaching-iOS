//
//  FollowUpController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

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
	var weightChartView: LineChartView!
	var bodyTitleLabel: UILabel!
	var bodyChartView: LineChartView!
	var bodyValues: UILabel!
	var measurementsTitle: UILabel!
	var measurementsChart: LineChartView!
	var measurementsValues: UILabel!
	
	var user: User?
	var measurements = [Measurements]()
	var displayedMeasurements = [Measurements]()
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
		dateFormatter.dateFormat = "yyyy/MM/dd"
		
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
		
		return sortedMeasurements
	}
}
