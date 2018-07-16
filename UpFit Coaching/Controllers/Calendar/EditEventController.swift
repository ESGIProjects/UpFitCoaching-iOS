//
//  EditEventController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka
import PKHUD

enum EditionMode {
	case add, edit
}

class EditEventController: FormViewController {
	
	var titleRow: TextRow!
	var typeRow: PushRow<Int>!
	var otherUserRow: SearchPushRow<User>?
	var startDateRow: DateTimeInlineRow!
	var endDateRow: DateTimeInlineRow!
	
	var editionMode = EditionMode.add
	var event: Event?
	
	var eventTitle: String!
	var type: Int!
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
			type = 0
			startDate = Date()
			endDate = startDate.addingTimeInterval(60 * 60)
			otherUser = currentUser?.coach
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(confirm))
		} else {
			title = "editEventController_editTitle".localized
			
			guard let currentUser = currentUser else { return }
			guard let event = event else { return }
			
			eventTitle = event.name
			type = event.type
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
			let event = Event(name: eventTitle, type: type, firstUser: currentUser, secondUser: otherUser, start: startDate, end: endDate, createdBy: currentUser, updatedBy: currentUser)
			event.eventID = Database().next(type: EventObject.self, of: "eventID") + 1
			
			add(event)
		} else {
			guard let event = event else { return }
			event.name = eventTitle
			event.type = type
			event.start = startDate
			event.end = endDate
			event.updated = Date()
			event.updatedBy = currentUser
			
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
	
	// MARK: - Helpers
	
	func add(_ event: Event) {
		
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
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
			} else {
				Network.displayError(self, from: data)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	func update(_ event: Event) {
		
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
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
			} else {
				Network.displayError(self, from: data)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	func toggleConfirmationButton() {
		var condition = startDate <= endDate && eventTitle != "" && type != nil
		
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
