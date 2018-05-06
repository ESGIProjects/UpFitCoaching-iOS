//
//  ConversationList+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ConversationListController {
	class UI {
		class func tableView(delegate: UITableViewDelegate?, dataSource: UITableViewDataSource?) -> UITableView {
			let tableView = UITableView(frame: .zero)
			tableView.translatesAutoresizingMaskIntoConstraints = false
			tableView.delegate = delegate
			tableView.dataSource = dataSource
			tableView.estimatedRowHeight = 100.0
			tableView.rowHeight = UITableViewAutomaticDimension
			return tableView
		}
		
		class func getConstraints(for controller: ConversationListController) -> [NSLayoutConstraint] {
			var constraints = [NSLayoutConstraint]()
			
			if #available(iOS 11.0, *) {
				constraints += [
					controller.tableView.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
					controller.tableView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor),
					controller.tableView.leadingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leadingAnchor),
					controller.tableView.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor)
				]
			} else {
				constraints += [
					controller.tableView.topAnchor.constraint(equalTo: controller.view.topAnchor),
					controller.tableView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
					controller.tableView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
					controller.tableView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor)
				]
			}
			
			return constraints
		}
	}
}
