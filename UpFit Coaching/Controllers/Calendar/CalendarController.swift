//
//  CalendarController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import JTAppleCalendar
import PKHUD

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
		title = "calendarController_title".localized
		view.backgroundColor = .white
		setupLayout()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "todayButton".localized, style: .plain, target: self, action: #selector(today))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
		
		// Register cells and notification
		calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarTableCell")
		NotificationCenter.default.addObserver(self, selector: #selector(reloadEvents), name: .eventsDownloaded, object: nil)
		
		// Display the correct month
		calendarView.visibleDates(updateMonthLabel)
		
		// Select the current date
		currentDate = Date()
		calendarView.selectDates([currentDate])
		calendarView.scrollToDate(currentDate, animateScroll: false)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		reloadEvents()
	}
	
	// MARK: - Layout
	
	func updateMonthLabel(visibleDates: DateSegmentInfo) {
		guard let date = visibleDates.monthDates.first?.date else { return }
		
		formatter.dateFormat = "MMMM yyyy"
		formatter.timeZone = Calendar.current.timeZone
		formatter.locale = Calendar.current.locale
		
		monthLabel.text = formatter.string(from: date).capitalizingFirstLetter()
	}
	
	func handleCell(cell: JTAppleCell?, cellState: CellState) {
		guard let cell = cell as? CalendarCell else { return }
		
		// Show or hide background
		cell.selectedBackground.isHidden = !cellState.isSelected || cellState.dateBelongsTo != .thisMonth
		
		// Show or hide dot
		let hasAppraisal = events.contains { Calendar.current.isDate($0.start, inSameDayAs: cellState.date) && $0.type == 0 } && cellState.dateBelongsTo == .thisMonth
		let hasSession = events.contains { Calendar.current.isDate($0.start, inSameDayAs: cellState.date) && $0.type == 1 } && cellState.dateBelongsTo == .thisMonth
		cell.setIndicators(appraisal: hasAppraisal, session: hasSession)
		
		// Select text color
		if cellState.dateBelongsTo == .thisMonth {
			if cellState.isSelected {
				cell.dateLabel.textColor = .calendarSelectedDayText
			} else {
				cell.dateLabel.textColor = .calendarDaysOfMonthText
			}
		} else {
			cell.dateLabel.textColor = .calendarDaysOutsideOfMonthText
		}
	}
	
	// MARK: - Actions
	
	@objc func today() {
		currentDate = Date()
		calendarView.selectDates([currentDate])
		calendarView.scrollToDate(currentDate, animateScroll: true)
	}
	
	@objc func addEvent() {
		let addEventController = EditEventController()
		present(UINavigationController(rootViewController: addEventController), animated: true)
	}
	
	// MARK: - Helpers
	
	@objc func reloadEvents() {
		events = Database().fetch(using: Event.all)
		todayEvents = events.filter { Calendar.current.isDate($0.start, inSameDayAs: currentDate) }
		todayEvents.sort { $0.start < $1.start }
		
		DispatchQueue.main.async { [weak self] in
			self?.calendarView.reloadData()
			self?.tableView.reloadData()
		}
	}
}
