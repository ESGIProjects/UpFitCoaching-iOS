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
			weightTitleLabel.topAnchor.constraint(equalTo: anchors.top, constant: 10.0),
			weightTitleLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			weightTitleLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			weightChartView.topAnchor.constraint(equalTo: weightTitleLabel.bottomAnchor, constant: 10.0),
			weightChartView.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			weightChartView.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			bodyTitleLabel.topAnchor.constraint(equalTo: weightChartView.bottomAnchor, constant: 10.0),
			bodyTitleLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			bodyTitleLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			bodyChartView.topAnchor.constraint(equalTo: bodyTitleLabel.bottomAnchor, constant: 10.0),
			bodyChartView.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			bodyChartView.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			weightChartView.heightAnchor.constraint(equalTo: bodyChartView.heightAnchor),
			
			BMILabel.topAnchor.constraint(equalTo: bodyChartView.bottomAnchor, constant: 10.0),
			BMILabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			
			BFPLabel.topAnchor.constraint(equalTo: bodyChartView.bottomAnchor, constant: 10.0),
			BFPLabel.leadingAnchor.constraint(equalTo: BMILabel.trailingAnchor, constant: 10.0),
			BFPLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			BMILabel.widthAnchor.constraint(equalTo: BFPLabel.widthAnchor),
			
			currentBMILabel.topAnchor.constraint(equalTo: BMILabel.bottomAnchor, constant: 5.0),
			currentBMILabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			currentBMILabel.bottomAnchor.constraint(equalTo: anchors.bottom, constant: -10.0),
			
			currentBFPLabel.topAnchor.constraint(equalTo: BFPLabel.bottomAnchor, constant: 5.0),
			currentBFPLabel.leadingAnchor.constraint(equalTo: currentBMILabel.trailingAnchor, constant: 10.0),
			currentBFPLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			currentBFPLabel.bottomAnchor.constraint(equalTo: anchors.bottom, constant: -10.0),
			
			currentBMILabel.widthAnchor.constraint(equalTo: currentBFPLabel.widthAnchor)
		]
	}
	
	fileprivate func setUIComponents() {
		weightTitleLabel = UI.genericLabel
		weightTitleLabel.text = "weightChart_title".localized
		weightTitleLabel.font = .boldSystemFont(ofSize: 20)
		
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
		
		BMILabel = UI.genericLabel
		BMILabel.text = "currentBmi_label".localized
		BMILabel.textAlignment = .center
		BMILabel.font = .boldSystemFont(ofSize: 19)
		
		currentBMILabel = UI.genericLabel
		currentBMILabel.text = "19"
		currentBMILabel.textColor = .followUpBMILine
		currentBMILabel.textAlignment = .center
		currentBMILabel.font = .systemFont(ofSize: 19)
		
		BFPLabel = UI.genericLabel
		BFPLabel.text = "currentBfp_label".localized
		BFPLabel.textAlignment = .center
		BFPLabel.font = .boldSystemFont(ofSize: 19)
		
		currentBFPLabel = UI.genericLabel
		currentBFPLabel.text = "22 %"
		currentBFPLabel.textColor = .followUpBFPLine
		currentBFPLabel.textAlignment = .center
		currentBFPLabel.font = .systemFont(ofSize: 19)
		
		// Data
		
		weightChartData = LineChartData()
		bodyChartData = LineChartData()

		generateBFP()
		generateBMI()
		generateWeight()
		
		weightChartView.data = weightChartData
		bodyChartView.data = bodyChartData
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(weightTitleLabel)
		view.addSubview(weightChartView)
		
		view.addSubview(bodyTitleLabel)
		view.addSubview(bodyChartView)
		
		view.addSubview(BMILabel)
		view.addSubview(currentBMILabel)
		
		view.addSubview(BFPLabel)
		view.addSubview(currentBFPLabel)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
