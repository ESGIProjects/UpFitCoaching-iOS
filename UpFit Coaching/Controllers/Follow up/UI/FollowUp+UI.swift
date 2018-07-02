//
//  FollowUp+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Charts

extension FollowUpController {
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			scrollView.topAnchor.constraint(equalTo: anchors.top),
			scrollView.leadingAnchor.constraint(equalTo: anchors.leading),
			scrollView.trailingAnchor.constraint(equalTo: anchors.trailing),
			scrollView.bottomAnchor.constraint(equalTo: anchors.bottom),
			
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			
			timeFilter.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
			timeFilter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			timeFilter.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			weightTitleLabel.topAnchor.constraint(equalTo: timeFilter.bottomAnchor, constant: 15.0),
			weightTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			
			weightLabel.centerYAnchor.constraint(equalTo: weightTitleLabel.centerYAnchor),
			weightLabel.leadingAnchor.constraint(equalTo: weightTitleLabel.trailingAnchor, constant: 15.0),
			weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			weightChartView.topAnchor.constraint(equalTo: weightTitleLabel.bottomAnchor, constant: 10.0),
			weightChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			weightChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			bodyTitleLabel.topAnchor.constraint(equalTo: weightChartView.bottomAnchor, constant: 15.0),
			bodyTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			bodyTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			bodyChartView.topAnchor.constraint(equalTo: bodyTitleLabel.bottomAnchor, constant: 10.0),
			bodyChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			bodyChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			bodyValues.topAnchor.constraint(equalTo: bodyChartView.bottomAnchor, constant: 10.0),
			bodyValues.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			bodyValues.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			measurementsTitle.topAnchor.constraint(equalTo: bodyValues.bottomAnchor, constant: 15.0),
			measurementsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			measurementsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			measurementsChart.topAnchor.constraint(equalTo: measurementsTitle.bottomAnchor, constant: 10.0),
			measurementsChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			measurementsChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			measurementsValues.topAnchor.constraint(equalTo: measurementsChart.bottomAnchor, constant: 10.0),
			measurementsValues.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			measurementsValues.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			measurementsValues.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0),
			
			weightChartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
			bodyChartView.heightAnchor.constraint(equalTo: weightChartView.heightAnchor),
			measurementsChart.heightAnchor.constraint(equalTo: weightChartView.heightAnchor)
		]
	}
	
	fileprivate func setUIComponents() {
		scrollView = UI.genericScrollView
		contentView = UI.genericView
		
		timeFilter = UISegmentedControl(items: ["Global", "Month", "Year"])
		timeFilter.translatesAutoresizingMaskIntoConstraints = false
		timeFilter.selectedSegmentIndex = 1
		timeFilter.addTarget(self, action: #selector(changeFilter), for: .valueChanged)
		
		weightTitleLabel = UI.genericLabel
		weightTitleLabel.text = "weightChart_title".localized
		weightTitleLabel.font = .boldSystemFont(ofSize: 20)
		
		weightLabel = UI.genericLabel
		
		weightChartView = UI.genericLineChart
		weightChartView.xAxis.enabled = false
		weightChartView.leftAxis.drawLabelsEnabled = false

		bodyTitleLabel = UI.genericLabel
		bodyTitleLabel.text = "bodyValuesChart_title".localized
		bodyTitleLabel.font = .boldSystemFont(ofSize: 20)
		
		bodyChartView = UI.genericLineChart
		bodyChartView.xAxis.enabled = false
		bodyChartView.leftAxis.drawLabelsEnabled = false
		bodyChartView.xAxis.drawGridLinesEnabled = false
		bodyChartView.xAxis.labelPosition = .bottom
		
		bodyValues = UI.bodyLabel
		bodyValues.numberOfLines = 2
		
		measurementsTitle = UI.genericLabel
		measurementsTitle.text = "measurementsChart_title".localized
		measurementsTitle.font = .boldSystemFont(ofSize: 20)
		
		measurementsChart = UI.genericLineChart
		measurementsChart.xAxis.enabled = false
		measurementsChart.leftAxis.drawLabelsEnabled = false
		
		measurementsValues = UI.bodyLabel
		measurementsValues.numberOfLines = 4
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		contentView.addSubview(timeFilter)
		contentView.addSubview(weightTitleLabel)
		contentView.addSubview(weightLabel)
		contentView.addSubview(weightChartView)
		contentView.addSubview(bodyTitleLabel)
		contentView.addSubview(bodyChartView)
		contentView.addSubview(bodyValues)
		contentView.addSubview(measurementsTitle)
		contentView.addSubview(measurementsChart)
		contentView.addSubview(measurementsValues)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
