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
	class UI {
		class func weightTitleLabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = "Poids"
			label.font = UIFont.boldSystemFont(ofSize: 20)
			return label
		}
		
		class func weightCharView() -> LineChartView {
			let view = LineChartView()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.chartDescription = nil
			view.drawGridBackgroundEnabled = false
			view.legend.enabled = false
			view.xAxis.enabled = false
//			view.noDataText = "Nothing to display"
			
			view.leftAxis.drawLabelsEnabled = false
			
			return view
		}
		
		class func bodyTitleLabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = "Indices corporels"
			label.font = UIFont.boldSystemFont(ofSize: 20)
			return label
		}
		
		class func bodyChartView() -> LineChartView {
			let view = LineChartView()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.chartDescription = nil
			view.drawGridBackgroundEnabled = false
			view.legend.enabled = false
//			view.noDataText = "Nothing to display"

			view.xAxis.drawGridLinesEnabled = false
			view.xAxis.labelPosition = .bottom
			view.leftAxis.drawLabelsEnabled = false
			
			return view
		}
		
		class func BMILabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = "IMC actuel"
			label.textAlignment = .center
			label.font = UIFont.boldSystemFont(ofSize: 19)
			return label
		}
		
		class func currentBMILabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = "19"
			label.textColor = .followUpBMILine
			label.textAlignment = .center
			label.font = UIFont.systemFont(ofSize: 19)
			return label
		}
		
		class func BFPLabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = "IMG actuel"
			label.textAlignment = .center
			label.font = UIFont.boldSystemFont(ofSize: 19)
			return label
		}
		
		class func currentBFPLabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = "22 %"
			label.textColor = .followUpBFPLine
			label.textAlignment = .center
			label.font = UIFont.systemFont(ofSize: 19)
			return label
		}
	}
	
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
		weightTitleLabel = UI.weightTitleLabel()
		weightChartView = UI.weightCharView()

		bodyTitleLabel = UI.bodyTitleLabel()
		bodyChartView = UI.bodyChartView()
		
		BMILabel = UI.BMILabel()
		currentBMILabel = UI.currentBMILabel()
		
		BFPLabel = UI.BFPLabel()
		currentBFPLabel = UI.currentBFPLabel()
		
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
