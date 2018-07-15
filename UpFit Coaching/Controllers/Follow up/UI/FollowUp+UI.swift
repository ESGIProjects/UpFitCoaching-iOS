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
			
			contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
			
			timeFilter.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
			timeFilter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			timeFilter.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			weightTitleLabel.topAnchor.constraint(equalTo: timeFilter.bottomAnchor, constant: 15.0),
			weightTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			
			weightLabel.centerYAnchor.constraint(equalTo: weightTitleLabel.centerYAnchor),
			weightLabel.leadingAnchor.constraint(equalTo: weightTitleLabel.trailingAnchor, constant: 15.0),
			weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			weightChart.topAnchor.constraint(equalTo: weightTitleLabel.bottomAnchor),
			weightChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			weightChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			bodyTitleLabel.topAnchor.constraint(equalTo: weightChart.bottomAnchor, constant: 20.0),
			bodyTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			bodyTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			bodyChart.topAnchor.constraint(equalTo: bodyTitleLabel.bottomAnchor),
			bodyChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			bodyChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			bodyValues.topAnchor.constraint(equalTo: bodyChart.bottomAnchor, constant: 20.0),
			bodyValues.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			bodyValues.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			measurementsTitle.topAnchor.constraint(equalTo: bodyValues.bottomAnchor, constant: 15.0),
			measurementsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			measurementsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			measurementsChart.topAnchor.constraint(equalTo: measurementsTitle.bottomAnchor),
			measurementsChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			measurementsChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			measurementsValues.topAnchor.constraint(equalTo: measurementsChart.bottomAnchor, constant: 20.0),
			measurementsValues.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			measurementsValues.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			measurementsValues.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0),
			
			weightChart.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
			bodyChart.heightAnchor.constraint(equalTo: weightChart.heightAnchor),
			measurementsChart.heightAnchor.constraint(equalTo: weightChart.heightAnchor)
		]
	}
	
	fileprivate func setUIComponents() {
		scrollView = UI.genericScrollView
		contentView = UI.genericView
		
		timeFilter = UISegmentedControl(items: ["timeFilter_global".localized, "timeFilter_year".localized, "timeFilter_month".localized])
		timeFilter.translatesAutoresizingMaskIntoConstraints = false
		timeFilter.selectedSegmentIndex = 2
		timeFilter.addTarget(self, action: #selector(changeFilter), for: .valueChanged)
		
		weightTitleLabel = UI.genericLabel
		weightTitleLabel.text = "weightChart_title".localized
		weightTitleLabel.font = .boldSystemFont(ofSize: 20)
		
		weightLabel = UI.genericLabel
		
		weightChart = UI.genericLineChart

		bodyTitleLabel = UI.genericLabel
		bodyTitleLabel.text = "bodyValuesChart_title".localized
		bodyTitleLabel.font = .boldSystemFont(ofSize: 20)
		
		bodyChart = UI.genericLineChart
		bodyChart.legend.enabled = true
		bodyChart.legend.horizontalAlignment = .center
		
		bodyValues = UI.bodyLabel
		bodyValues.numberOfLines = 2
		
		measurementsTitle = UI.genericLabel
		measurementsTitle.text = "measurementsChart_title".localized
		measurementsTitle.font = .boldSystemFont(ofSize: 20)
		
		measurementsChart = UI.genericLineChart
		measurementsChart.legend.enabled = true
		measurementsChart.legend.horizontalAlignment = .center
		
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
		contentView.addSubview(weightChart)
		contentView.addSubview(bodyTitleLabel)
		contentView.addSubview(bodyChart)
		contentView.addSubview(bodyValues)
		contentView.addSubview(measurementsTitle)
		contentView.addSubview(measurementsChart)
		contentView.addSubview(measurementsValues)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
