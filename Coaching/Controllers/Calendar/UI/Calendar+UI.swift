//
//  Calendar+UI.swift
//  Coaching
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
			label.textColor = .white
			label.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.8117647059, blue: 0.831372549, alpha: 1)
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
				label.textColor = .gray
			}
			
			let view = UIStackView(arrangedSubviews: labels)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.distribution = .fillEqually
			return view
		}
		
		class func calendarView(delegate: JTAppleCalendarViewDelegate? = nil, dataSource: JTAppleCalendarViewDataSource? = nil) -> JTAppleCalendarView {
			let view = JTAppleCalendarView(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			// Protocols
			view.calendarDelegate = delegate
			view.calendarDataSource = dataSource
			
			// Settings
			view.scrollDirection = .horizontal
			view.showsVerticalScrollIndicator = false
			view.showsHorizontalScrollIndicator = false
			view.isPagingEnabled = true
			
			// Layout
			view.backgroundColor = .white
			
			return view
		}
		
		class func tableView(delegate: UITableViewDelegate? = nil, dataSource: UITableViewDataSource? = nil) -> UITableView {
			let view = UITableView(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.delegate = delegate
			view.dataSource = dataSource
			
			return view
		}
	}
}
