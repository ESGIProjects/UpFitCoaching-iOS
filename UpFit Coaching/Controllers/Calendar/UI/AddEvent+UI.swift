//
//  AddEvent+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension AddEventController {
	class UI {
		class func tableView(delegate: UITableViewDelegate? = nil, dataSource: UITableViewDataSource? = nil) -> UITableView {
			let view = UITableView(frame: .zero, style: .grouped)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.delegate = delegate
			view.dataSource = dataSource
			return view
		}
	}
	
	func getConstraints(for controller: AddEventController) -> [NSLayoutConstraint] {
		let anchors = controller.getAnchors()
		
		return [
			tableView.topAnchor.constraint(equalTo: anchors.top),
			tableView.bottomAnchor.constraint(equalTo: anchors.bottom),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
}
