//
//  AddEventController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class AddEventController: FormViewController {
	
	var titleRow: TextRow!
	var otherUserRow: PushRow<String>?
	var startDateRow: DateTimeInlineRow!
	var endDateRow: DateTimeInlineRow!
	
	let currentUser = Database().getCurrentUser()
	var otherUser: User?
	
	var eventTitle = ""
	var startDate = Date()
	var endDate = Date().addingTimeInterval(60 * 60)
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Layout
		title = "addEventController_title".localized
		setupLayout()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(add))
		toggleAddButton()
	}
	
	// MARK: - Actions
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	@objc func add() {
		guard let currentUser = currentUser else { return }
//		guard let otherUser = otherUser else { return }
		let otherUser = currentUser // temp
		
		let event = Event(name: eventTitle, type: 0, client: currentUser, coach: otherUser, start: startDate, end: endDate, createdBy: currentUser, updatedBy: currentUser)
		event.eventID = Database().next(type: EventObject.self, of: "eventID") + 1
		
		print(event)
		
		Network.addEvent(event, by: currentUser) { [weak self] data, response, _ in
			guard let data = data else { return }

			if Network.isSuccess(response: response, successCode: 201) {
				// Creating the JSON decoder
				let decoder = JSONDecoder.withDate

				// Decode new event
				guard let newEvent = try? decoder.decode(Event.self, from: data) else { return }

				// Save event
				Database().createOrUpdate(model: newEvent, with: EventObject.init)

				// Dismiss controller
				self?.navigationController?.dismiss(animated: true)
			}
		}
	}
	
	func toggleAddButton() {
		navigationItem.rightBarButtonItem?.isEnabled = startDate <= endDate && eventTitle != ""
	}
	
	func validateDates() {
		if startDate > endDate {
			endDateRow.cell.textLabel?.textColor = .red
		} else {
			endDateRow.cell.textLabel?.textColor = .black
		}
	}
}
