//
//  ConversationListController+Layout.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ConversationListController {
	
	// MARK: - Creating elements
	
	func createTableView() -> UITableView {
		let tableView = UITableView(frame: .zero)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}
}
