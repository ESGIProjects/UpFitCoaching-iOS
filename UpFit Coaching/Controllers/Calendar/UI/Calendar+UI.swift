//
//  Calendar+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import JTAppleCalendar

extension CalendarController {
	func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			monthLabel.topAnchor.constraint(equalTo: anchors.top),
			monthLabel.leadingAnchor.constraint(equalTo: anchors.leading),
			monthLabel.trailingAnchor.constraint(equalTo: anchors.trailing),
			monthLabel.heightAnchor.constraint(equalToConstant: 45.0),
			
			weekdaysHeaderView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 10.0),
			weekdaysHeaderView.leadingAnchor.constraint(equalTo: anchors.leading),
			weekdaysHeaderView.trailingAnchor.constraint(equalTo: anchors.trailing),
			
			calendarView.topAnchor.constraint(equalTo: weekdaysHeaderView.bottomAnchor),
			calendarView.leadingAnchor.constraint(equalTo: anchors.leading),
			calendarView.trailingAnchor.constraint(equalTo: anchors.trailing),
			calendarView.heightAnchor.constraint(equalToConstant: 240.0),
			
			tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing),
			tableView.bottomAnchor.constraint(equalTo: anchors.bottom)
		]
	}
	
	func setUIComponents() {
		monthLabel = UI.genericLabel
		monthLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
		monthLabel.textAlignment = .center
		monthLabel.textColor = .white
		monthLabel.backgroundColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
		
		weekdaysHeaderView = UI.calendarWeekdaysHeader
		
		calendarView = UI.genericCalendar
		calendarView.calendarDelegate = self
		calendarView.calendarDataSource = self
		
		tableView = UI.genericTableView
		tableView.separatorInset = .zero
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(monthLabel)
		view.addSubview(weekdaysHeaderView)
		view.addSubview(calendarView)
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
