//
//  Calendar+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import JTAppleCalendar

extension CalendarController {
	class UI {
		class func monthLabel() -> UILabel {
			let label = UILabel(frame: .zero)
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.font = UIFont.boldSystemFont(ofSize: 24.0)
			label.textAlignment = .center
			label.textColor = .calendarMonthText
			label.backgroundColor = .calendarMonthBackground
			
			return label
		}
		
		class func weekdaysHeaderView() -> UIStackView {
			let labels = [
				UILabel(frame: .zero),
				UILabel(frame: .zero),
				UILabel(frame: .zero),
				UILabel(frame: .zero),
				UILabel(frame: .zero),
				UILabel(frame: .zero),
				UILabel(frame: .zero)
			]
			
			labels[0].text = "monday_short".localized
			labels[1].text = "tuesday_short".localized
			labels[2].text = "wednesday_short".localized
			labels[3].text = "thursday_short".localized
			labels[4].text = "friday_short".localized
			labels[5].text = "saturday_short".localized
			labels[6].text = "sunday_short".localized
			
			for label in labels {
				label.textAlignment = .center
				label.textColor = .disabled
			}
			
			let view = UIStackView(arrangedSubviews: labels)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.distribution = .fillEqually
			
			return view
		}
		
		class func calendarView() -> JTAppleCalendarView {
			let view = JTAppleCalendarView(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			// Settings
			view.scrollDirection = .horizontal
			view.showsVerticalScrollIndicator = false
			view.showsHorizontalScrollIndicator = false
			view.scrollingMode = .stopAtEachSection
			view.isPagingEnabled = true
			
			// Layout
			view.backgroundColor = .background
			
			return view
		}
		
		class func tableView() -> UITableView {
			let view = UITableView(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.separatorInset = .zero
			return view
		}
	}
	
	func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			monthLabel.topAnchor.constraint(equalTo: anchors.top),
			monthLabel.leadingAnchor.constraint(equalTo: anchors.leading),
			monthLabel.trailingAnchor.constraint(equalTo: anchors.trailing),
			monthLabel.heightAnchor.constraint(equalToConstant: 50.0),
			
			weekdaysHeaderView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 10.0),
			weekdaysHeaderView.leadingAnchor.constraint(equalTo: anchors.leading),
			weekdaysHeaderView.trailingAnchor.constraint(equalTo: anchors.trailing),
			
			calendarView.topAnchor.constraint(equalTo: weekdaysHeaderView.bottomAnchor),
			calendarView.leadingAnchor.constraint(equalTo: anchors.leading),
			calendarView.trailingAnchor.constraint(equalTo: anchors.trailing),
			calendarView.heightAnchor.constraint(equalToConstant: 250),
			
			tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing),
			tableView.bottomAnchor.constraint(equalTo: anchors.bottom)
		]
	}
	
	func setUIComponents() {
		monthLabel = UI.monthLabel()
		weekdaysHeaderView = UI.weekdaysHeaderView()
		
		calendarView = UI.calendarView()
		calendarView.calendarDelegate = self
		calendarView.calendarDataSource = self
		
		tableView = UI.tableView()
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
