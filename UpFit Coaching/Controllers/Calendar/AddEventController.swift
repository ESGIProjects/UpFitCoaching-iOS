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
	
	enum EditionMode {
		case add, edit
	}
	
	var titleRow: TextRow!
	var otherUserRow: PushRow<User>?
	var startDateRow: DateTimeInlineRow!
	var endDateRow: DateTimeInlineRow!
	
	var editionMode = EditionMode.add
	var event: Event?
	
	var eventTitle: String!
	var startDate: Date!
	var endDate: Date!
	let currentUser = Database().getCurrentUser()
	var otherUser: User?
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if editionMode == .add {
			title = "editEventController_addTitle".localized
			
			eventTitle = ""
			startDate = Date()
			endDate = startDate.addingTimeInterval(60 * 60)
			otherUser = currentUser?.coach
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(confirm))
		} else {
			title = "editEventController_editTitle".localized
			
			guard let currentUser = currentUser else { return }
			guard let event = event else { return }
			
			eventTitle = event.name
			startDate = event.start
			endDate = event.end
			otherUser = event.firstUser == currentUser ? event.secondUser : event.firstUser
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirm))
		}
		
		setupLayout()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toggleConfirmationButton()
	}
	
	// MARK: - Actions
	
	@objc func confirm() {
		guard let currentUser = currentUser else { return }
		guard let otherUser = otherUser else { return }
		
		if editionMode == .add {
			let event = Event(name: eventTitle, type: 0, firstUser: currentUser, secondUser: otherUser, start: startDate, end: endDate, createdBy: currentUser, updatedBy: currentUser)
			event.eventID = Database().next(type: EventObject.self, of: "eventID") + 1
			
			add(event)
		} else {
			guard let event = event else { return }
			event.name = eventTitle
			event.start = startDate
			event.end = endDate
			event.updated = Date()
			
			if event.firstUser == currentUser {
				event.secondUser = otherUser
			} else {
				event.firstUser = otherUser
			}
			
			update(event)
		}
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	@objc func delete() {
		
	}
	
	// MARK: - Helpers
	
	func add(_ event: Event) {
		Network.addEvent(event) { [weak self] data, response, _ in
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
	
	func update(_ event: Event) {
		Network.updateEvent(event) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Creating the JSON decoder
				let decoder = JSONDecoder.withDate
				
				// Decode updated event
				guard let updatedEvent = try? decoder.decode(Event.self, from: data) else { return }
				
				// Save event
				Database().createOrUpdate(model: updatedEvent, with: EventObject.init)
				
				// Dismiss controller
				self?.navigationController?.dismiss(animated: true)
			}
		}
	}
	
	func delete(_ event: Event) {
		
	}
	
	func toggleConfirmationButton() {
		var condition = startDate <= endDate && eventTitle != ""
		
		if currentUser?.type == 2 {
			condition = condition && otherUser != nil
		}
		
		navigationItem.rightBarButtonItem?.isEnabled = condition
	}
	
	func validateDates() {
		if startDate > endDate {
			endDateRow.cell.textLabel?.textColor = .red
		} else {
			endDateRow.cell.textLabel?.textColor = .black
		}
	}
}
