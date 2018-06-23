//
//  ClientsList+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ClientsListController {
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			tableView.topAnchor.constraint(equalTo: anchors.top),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing),
			tableView.bottomAnchor.constraint(equalTo: anchors.bottom)
		]
	}
	
	fileprivate func setUIComponents() {
		tableView = UI.genericTableView
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(tableView)
		NSLayoutConstraint.activate(getConstraints())
	}
}
