//
//  Thread+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ThreadController {	
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			tableView.topAnchor.constraint(equalTo: anchors.top),
			tableView.bottomAnchor.constraint(equalTo: anchors.bottom),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
	
	fileprivate func setUIComponents() {
		tableView = UI.genericTableView
		tableView.separatorInset = .zero
		tableView.dataSource = self
		tableView.delegate = self
		tableView.tableFooterView = UIView(frame: .zero)
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(tableView)
		NSLayoutConstraint.activate(getConstraints())
	}
}
