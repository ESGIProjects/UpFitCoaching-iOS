//
//  ConversationList+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ConversationListController {
	func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
	
	func setUIComponents() {
		tableView = UI.genericTableView
		tableView.estimatedRowHeight = 100.0
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.delegate = self
		tableView.dataSource = self
		
		refreshControl = UIRefreshControl()
		refreshControl.tintColor = .white
		refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(tableView)
		tableView.refreshControl = refreshControl
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
