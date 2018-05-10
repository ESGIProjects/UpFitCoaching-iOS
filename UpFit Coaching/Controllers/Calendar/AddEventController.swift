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
	
	// MARK: - UI Logic
	
	var startIndexPath = IndexPath(row: 0, section: 1)
	
	var endIndexPath: IndexPath {
		if currentPicker == .start {
			return IndexPath(row: 2, section: 1)
		} else {
			return IndexPath(row: 1, section: 1)
		}
	}
	
	var currentPicker = DatePicker.none {
		didSet {
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
	
	var pickerIndexPath: IndexPath?
	
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
	
	@objc private func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	@objc private func add() {
		// Creating Event struct
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
	
	@objc private func editTitle() {
		guard let text = titleTextField.text else { return }
		navigationItem.rightBarButtonItem?.isEnabled = !text.isEmpty
	}
	
	@objc private func changeDate() {
		
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
}

// MARK: - UITableViewDelegate
extension AddEventController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if indexPath == startIndexPath {
			currentPicker = currentPicker == .start ? .none : .start
			startValueLabel.textColor = currentPicker == .start ? .red : .black
			endValueLabel.textColor = .black
		} else if indexPath == endIndexPath {
			currentPicker = currentPicker == .end ? .none : .end
			startValueLabel.textColor = .black
			endValueLabel.textColor = currentPicker == .end ? .red : .black
		}
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return indexPath == startIndexPath || indexPath == endIndexPath
	}
}

// MARK: - UITableViewDataSource
extension AddEventController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath == pickerIndexPath {
			return UITableViewAutomaticDimension
		}
		
		return 44.0
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return 2 + (currentPicker != .none ? 1 : 0)
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			let cell = UITableViewCell()
			cell.contentView.addSubview(titleTextField)
			
			NSLayoutConstraint.activate([

				titleTextField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				titleTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20.0),
				titleTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20.0),
				titleTextField.heightAnchor.constraint(equalToConstant: 30)
				])
			
			return cell
			
		case (startIndexPath.section, startIndexPath.row):
			return UI.startCell(startLabel, startValueLabel)
			
		case (endIndexPath.section, endIndexPath.row):
			return UI.endCell(endLabel, endValueLabel)
			
		case (pickerIndexPath?.section, pickerIndexPath?.row):
			return UI.pickerCell(datePicker)
			
		default:
			return UITableViewCell()
		}
	}
}
