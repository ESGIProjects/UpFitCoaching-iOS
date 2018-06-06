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
