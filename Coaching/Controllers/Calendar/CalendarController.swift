//
//  CalendarController.swift
//  Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarController: UIViewController {
	
	let formatter = DateFormatter()
	
	// MARK: - UI
	
	lazy var monthLabel = UI.monthLabel()
	lazy var weekdaysHeaderView = UI.weekdaysHeaderView()
	lazy var calendarView = UI.calendarView(delegate: self, dataSource: self)
	lazy var tableView = UI.tableView(delegate: self, dataSource: self)
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setting up layout
		title = "calendar_title".localized
		setupLayout()
		
		// Register cells
		calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarTableCell")
		
		// Display the correct month
		calendarView.visibleDates(updateMonthLabel)
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
		
		var topAnchor: NSLayoutYAxisAnchor
		var bottomAnchor: NSLayoutYAxisAnchor
		var leadingAnchor: NSLayoutXAxisAnchor
		var trailingAnchor: NSLayoutXAxisAnchor
		
		if #available(iOS 11.0, *) {
			topAnchor = view.safeAreaLayoutGuide.topAnchor
			bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
			leadingAnchor = view.safeAreaLayoutGuide.leadingAnchor
			trailingAnchor = view.safeAreaLayoutGuide.trailingAnchor
		} else {
			topAnchor = view.topAnchor
			bottomAnchor = view.bottomAnchor
			leadingAnchor = view.leadingAnchor
			trailingAnchor = view.trailingAnchor
		}
		
		NSLayoutConstraint.activate([
			monthLabel.topAnchor.constraint(equalTo: topAnchor),
			monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			monthLabel.heightAnchor.constraint(equalToConstant: 50.0),
			
			weekdaysHeaderView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor),
			weekdaysHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
			weekdaysHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			calendarView.topAnchor.constraint(equalTo: weekdaysHeaderView.bottomAnchor),
			calendarView.leadingAnchor.constraint(equalTo: leadingAnchor),
			calendarView.trailingAnchor.constraint(equalTo: trailingAnchor),
			calendarView.heightAnchor.constraint(equalToConstant: 250),
			
			tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
			])
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
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "CalendarTableCell")
		cell.textLabel?.text = "Hello world"
		return cell
	}
}
