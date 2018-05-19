//
//  CalendarController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarController: UIViewController {
	
	// MARK: - UI
	
	var monthLabel: UILabel!
	var weekdaysHeaderView: UIStackView!
	var calendarView: JTAppleCalendarView!
	var tableView: UITableView!
	
	// MARK: - Data
	
	let formatter = DateFormatter()
	let currentUser = Database().getCurrentUser()
	
	var events = [Event]()
	var todayEvents = [Event]()
	
	var currentDate: Date! {
		didSet {
			reloadEvents()
		}
	}
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setting up layout
		title = "calendar_title".localized
		setupLayout()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
		
		// Register cells and notification
		calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarTableCell")
		NotificationCenter.default.addObserver(self, selector: #selector(eventsDownloaded), name: .eventsDownloaded, object: nil)
		
		// Display the correct month
		calendarView.visibleDates(updateMonthLabel)
		
		// Select the current date
		currentDate = Date()
		calendarView.selectDates([currentDate])
		calendarView.scrollToDate(currentDate, animateScroll: false)
		
		// Download all events
		downloadEvents()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		reloadEvents()
	}
	
	// MARK: - Layout
	
	func updateMonthLabel(visibleDates: DateSegmentInfo) {
		guard let date = visibleDates.monthDates.first?.date else { return }
		
		formatter.dateFormat = "MMMM yyyy"
		formatter.timeZone = Calendar.current.timeZone
		formatter.locale = Calendar.current.locale
		
		monthLabel.text = formatter.string(from: date)
	}
	
	func handleCell(cell: JTAppleCell?, cellState: CellState) {
		guard let cell = cell as? CalendarCell else { return }
		
		// Show or hide background
		cell.selectedBackground.isHidden = !cellState.isSelected || cellState.dateBelongsTo != .thisMonth
		
		// Select text color
		if cellState.dateBelongsTo == .thisMonth {
			if cellState.isSelected {
				cell.dateLabel.textColor = .selectedDate
			} else {
				cell.dateLabel.textColor = .currentMonthDates
			}
		} else {
			cell.dateLabel.textColor = .outsideMonthDates
		}
	}
	
	// MARK: - Actions
	
	@objc func addEvent() {
		let addEventController = AddEventController()
		present(UINavigationController(rootViewController: addEventController), animated: true)
	}
	
	@objc func eventsDownloaded() {
		reloadEvents()
	}
	
	// MARK: - Helpers
	
	func downloadEvents() {
		guard let currentUser = currentUser else { return }
		
		Network.getEvents(for: currentUser) { data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode events list
				let decoder = JSONDecoder.withDate
				guard let events = try? decoder.decode([Event].self, from: data) else { return }
				
				// Save events
				let database = Database()
				database.deleteAll(of: EventObject.self)
				database.createOrUpdate(models: events, with: EventObject.init)
				
				// Post a notification telling its done
				NotificationCenter.default.post(name: .eventsDownloaded, object: nil)
			}
		}
	}
	
	func reloadEvents() {
		events = Database().fetch(using: Event.all)
		todayEvents = events.filter { Calendar.current.isDate($0.start, inSameDayAs: currentDate) }
		
		DispatchQueue.main.async { [weak self] in
			self?.calendarView.reloadData()
			self?.tableView.reloadData()
		}
	}
}
