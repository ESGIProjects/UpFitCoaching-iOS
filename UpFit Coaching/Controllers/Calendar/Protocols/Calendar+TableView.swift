//
//  Calendar+TableViewDelegate.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension CalendarController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let event = todayEvents[indexPath.row]
		
		let eventController = EventController()
		eventController.event = event
		
		navigationController?.pushViewController(eventController, animated: true)
	}
}

extension CalendarController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		
		if todayEvents.count > 0 {
			tableView.separatorColor = .gray
			tableView.backgroundView = nil
			return 1
		}
		
		let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
		messageLabel.text = "nothingThisDay".localized
		messageLabel.textColor = .gray
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
		messageLabel.sizeToFit()
		
		tableView.separatorColor = .clear
		tableView.backgroundView = messageLabel
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todayEvents.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: CalendarTableCell
		
		if let reusableCell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableCell", for: indexPath) as? CalendarTableCell {
			cell = reusableCell
		} else {
			cell = CalendarTableCell(style: .default, reuseIdentifier: "CalendarTableCell")
		}
		
		let event = todayEvents[indexPath.row]
		
		cell.textLabel?.text = event.name
		
		return cell
	}
}
