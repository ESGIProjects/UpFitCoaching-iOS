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
	
	lazy var monthLabel = UI.monthLabel()
	lazy var weekdaysHeaderView = UI.weekdaysHeaderView()
	lazy var calendarView = UI.calendarView(delegate: self, dataSource: self)
	lazy var tableView = UI.tableView(delegate: self, dataSource: self)
	
	// MARK: - Data
	
	let formatter = DateFormatter()
	let currentUser = Database().getCurrentUser()
	lazy var events: [Event] = Database().fetch(using: Event.all)
	var todayEvents = [Event]()
	
	var currentDate: Date! {
		didSet {
			todayEvents = events.filter { Calendar.current.isDate($0.start, inSameDayAs: currentDate) }
			
			calendarView.reloadData()
			tableView.reloadData()
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
		
		// Creating fake data
		guard let currentUser = currentUser else { return }
		
		if events.count == 0 {
			let firstDate = Date()
			let secondDate = firstDate.addingTimeInterval(60 * 60 * 24 * 2)
			
			let firstEvent = Event(eventID: 1, name: "Premier rendez-vous", client: currentUser, coach: currentUser, start: firstDate, end: firstDate.addingTimeInterval(3600), created: firstDate, updated: firstDate)
			let secondEvent = Event(eventID: 2, name: "Second rendez-vous", client: currentUser, coach: currentUser, start: secondDate, end: secondDate.addingTimeInterval(3600*2), created: firstDate, updated: firstDate)
			
			let database = Database()
			database.createOrUpdate(model: firstEvent, with: EventObject.init)
			database.createOrUpdate(model: secondEvent, with: EventObject.init)
			
			events = database.fetch(using: Event.all)
			calendarView.reloadData()
			tableView.reloadData()
		}
	}
	
	// MARK: - Layout
	
	private func updateMonthLabel(visibleDates: DateSegmentInfo) {
		guard let date = visibleDates.monthDates.first?.date else { return }
		
		formatter.dateFormat = "MMMM yyyy"
		formatter.timeZone = Calendar.current.timeZone
		formatter.locale = Calendar.current.locale
		
		monthLabel.text = formatter.string(from: date)
	}
	
	private func setupLayout() {
		view.addSubview(monthLabel)
		view.addSubview(weekdaysHeaderView)
		view.addSubview(calendarView)
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate(UI.getConstraints(for: self))
	}
	
	private func handleCell(cell: JTAppleCell?, cellState: CellState) {
		guard let cell = cell as? CalendarCell else { return }
		
		// Show or hide background
		cell.selectedBackground.isHidden = !cellState.isSelected || cellState.dateBelongsTo != .thisMonth
		
		// Select text color
		if cellState.dateBelongsTo == .thisMonth {
			cell.dateLabel.textColor = cellState.isSelected ? .selectedDate : .currentMonthDates
		} else {
			cell.dateLabel.textColor = .outsideMonthDates
		}
	}
	
	// MARK: - Actions
	
	@objc private func addEvent() {
		let addEventController = AddEventController()
		present(UINavigationController(rootViewController: addEventController), animated: true)
	}
}

// MARK: - JTAppleCalendarViewDelegate
extension CalendarController: JTAppleCalendarViewDelegate {
	func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {}
	
	func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
		var cell: CalendarCell
		
		if let reusableCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell {
			cell = reusableCell
		} else {
			cell = CalendarCell(frame: .zero)
		}
	
		cell.dateLabel.text = cellState.text
		handleCell(cell: cell, cellState: cellState)
		
		return cell
	}
	
	func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
		handleCell(cell: cell, cellState: cellState)
		print(cellState.date)
		currentDate = cellState.date
	}
	
	func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
		handleCell(cell: cell, cellState: cellState)
	}
	
	func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
		updateMonthLabel(visibleDates: visibleDates)
	}
	
	func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
		return cellState.dateBelongsTo == .thisMonth
	}
	
	func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
		return cellState.dateBelongsTo == .thisMonth
	}
}

// MARK: - JTAppleCalendarViewDataSource
extension CalendarController: JTAppleCalendarViewDataSource {
	func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
		
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.timeZone = Calendar.current.timeZone
		formatter.locale = Calendar.current.locale
		
		guard let startDate = formatter.date(from: "2018-01-01"), let endDate = formatter.date(from: "2018-12-31") else { fatalError() }
		
		let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: nil, calendar: nil, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: .monday, hasStrictBoundaries: nil)
		return parameters
	}
}

// MARK: - UITableViewDelegate
extension CalendarController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - UITableViewDataSource
extension CalendarController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		
		if todayEvents.count > 0 {
			tableView.separatorColor = .gray
			tableView.backgroundView = nil
			return 1
		}
		
		let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
		messageLabel.text = "Nothing scheduled this day"
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
