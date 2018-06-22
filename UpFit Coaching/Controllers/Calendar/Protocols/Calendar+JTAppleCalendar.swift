//
//  Calendar+DataSource.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import JTAppleCalendar

extension CalendarController: JTAppleCalendarViewDataSource {
	func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
		
		let currentYear = Calendar.current.component(.year, from: Date())
		let startYear = currentYear - 5
		let endYear = currentYear + 5
		
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.timeZone = Calendar.current.timeZone
		formatter.locale = Calendar.current.locale
		
		guard let startDate = formatter.date(from: "\(startYear)-01-01"),
			let endDate = formatter.date(from: "\(endYear)-12-31") else { fatalError() }
		
		return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: nil, calendar: nil, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: .monday, hasStrictBoundaries: nil)
	}
}

extension CalendarController: JTAppleCalendarViewDelegate {
	func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
		
	}
	
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
