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
		
		// Register cells
		calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarTableCell")
		
		// Display the correct month
		calendarView.visibleDates(updateMonthLabel)
		
		// Select the current date
		currentDate = Date()
		calendarView.selectDates([currentDate])
		calendarView.scrollToDate(currentDate, animateScroll: false)
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
	
	// MARK: - Helpers
	
	func reloadEvents() {
		events = Database().fetch(using: Event.all)
		todayEvents = events.filter { Calendar.current.isDate($0.start, inSameDayAs: currentDate) }
		
		calendarView.reloadData()
		tableView.reloadData()
	}
}
