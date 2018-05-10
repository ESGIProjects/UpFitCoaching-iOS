//
//  AddEventController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class AddEventController: UIViewController {
	
	enum DatePicker {
		case start, end, none
	}
	
	// MARK: - UI
	
	var tableView: UITableView!
	var titleTextField: UITextField!
	var startLabel: UILabel!
	var startValueLabel: UILabel!
	var endLabel: UILabel!
	var endValueLabel: UILabel!
	var datePicker: UIDatePicker!
	
	var startIndexPath = IndexPath(row: 0, section: 1)
	var endIndexPath: IndexPath {
		if currentPicker == .start {
			return IndexPath(row: 2, section: 1)
		} else {
			return IndexPath(row: 1, section: 1)
		}
	}
	
	var pickerIndexPath: IndexPath?
	var currentPicker = DatePicker.none {
		didSet {
			displayPicker(oldValue)
		}
	}
	
	let dateFormatter = DateFormatter()
	
	// MARK: - Data
	
	let currentUser = Database().getCurrentUser()
	var otherUser: User?
	
	var startDate = Date()
	var endDate = Date().addingTimeInterval(60 * 60)
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		// Date formatter
		dateFormatter.locale = Locale.current
		dateFormatter.timeZone = TimeZone.current
		
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .short
		
		// Layout
		title = "addEvent_title".localized
		setupLayout()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add_button".localized, style: .done, target: self, action: #selector(add))
		navigationItem.rightBarButtonItem?.isEnabled = false
		
		startValueLabel.text = dateFormatter.string(from: startDate)
		endValueLabel.text = dateFormatter.string(from: endDate)
		
		// Observes value changes
		titleTextField.addTarget(self, action: #selector(editTitle), for: .editingChanged)
		datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
	}
	
	// MARK: - Actions
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	@objc func add() {
		guard let eventTitle = titleTextField.text else { return }
		guard let currentUser = currentUser else { return }
//		guard let otherUser = otherUser else { return }
		let otherUser = currentUser // temp
		
		let database = Database()
		
		let event = Event(name: eventTitle, type: 0, client: currentUser, coach: otherUser, start: startDate, end: endDate, createdBy: currentUser, updatedBy: currentUser)
		event.eventID = database.next(type: EventObject.self, of: "eventID") + 1
		
		// ... api call ...
		
		database.createOrUpdate(model: event, with: EventObject.init)
		navigationController?.dismiss(animated: true)
	}
	
	@objc func editTitle() {
		guard let text = titleTextField.text else { return }
		navigationItem.rightBarButtonItem?.isEnabled = !text.isEmpty
	}
	
	@objc func changeDate() {
		// Configure formatter
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .short
		
		// Updates dates
		if currentPicker == .start {
			startDate = datePicker.date
			startValueLabel.text = dateFormatter.string(from: startDate)
		} else {
			endDate = datePicker.date
		}
		
		// Updates end value
		if Calendar.current.isDate(startDate, inSameDayAs: endDate) {
			dateFormatter.dateStyle = .none
			dateFormatter.timeStyle = .short
		}
		
		let endValue = dateFormatter.string(from: endDate)
		
		if startDate > endDate {
			let attributedString = NSMutableAttributedString(string: endValue)
			attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributedString.length))
			endValueLabel.attributedText = attributedString
		} else {
			endValueLabel.text = endValue
		}
	}
	
	// MARK: - Helpers
	
	func displayPicker(_ oldValue: DatePicker) {
		// Setting the same value : do nothing
		if currentPicker == oldValue { return }
		
		tableView.beginUpdates()
		
		// Delete the old picker
		if let indexPath = pickerIndexPath {
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
		
		if currentPicker == .none {
			pickerIndexPath = nil
		}
		
		if currentPicker == .start {
			datePicker.date = startDate
			
			let indexPath = IndexPath(row: startIndexPath.row + 1, section: startIndexPath.section)
			pickerIndexPath = indexPath
			tableView.insertRows(at: [indexPath], with: .fade)
		}
		
		if currentPicker == .end {
			datePicker.date = endDate
			
			let indexPath = IndexPath(row: endIndexPath.row + 1, section: endIndexPath.section)
			pickerIndexPath = indexPath
			tableView.insertRows(at: [indexPath], with: .fade)
		}
		
		tableView.endUpdates()
	}
}
