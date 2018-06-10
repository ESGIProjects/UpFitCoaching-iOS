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
		class func lineChartView() -> LineChartView {
			let view = LineChartView()
			view.translatesAutoresizingMaskIntoConstraints = false
			view.noDataText = "Nothing to display"
			return view
		}
	}
	
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			lineChartView.topAnchor.constraint(equalTo: anchors.top),
			lineChartView.bottomAnchor.constraint(equalTo: anchors.bottom),
			lineChartView.leadingAnchor.constraint(equalTo: anchors.leading),
			lineChartView.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
	
	fileprivate func setUIComponents() {
		lineChartView = UI.lineChartView()
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(lineChartView)
		NSLayoutConstraint.activate(getConstraints())
	}
}
