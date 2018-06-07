//
//  Forum+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ForumController {
	class UI {
		class func tableView() -> UITableView {
			let view = UITableView(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			return view
		}
	}
	
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
		tableView = UI.tableView()
		tableView.dataSource = self
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(tableView)
		NSLayoutConstraint.activate(getConstraints())
	}
}
