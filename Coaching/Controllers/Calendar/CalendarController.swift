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
	
	lazy var calendar: JTAppleCalendarView = {
		let view = JTAppleCalendarView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		// Design to edit
		view.backgroundColor = .gray
		
		// Settings
		view.calendarDelegate = self
		view.calendarDataSource = self
		view.scrollDirection = .horizontal
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.isPagingEnabled = true
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		calendar.register(CustomCell.self, forCellWithReuseIdentifier: "CustomCell")
		
		setupLayout()
	}
	
	private func setupLayout() {
		view.addSubview(calendar)
		
		NSLayoutConstraint.activate([
			calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			calendar.topAnchor.constraint(equalTo: view.topAnchor),
			calendar.heightAnchor.constraint(equalToConstant: 327)
			])
	}
}

extension CalendarController: JTAppleCalendarViewDelegate {
	func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
		
	}
	
	func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
		var cell: CustomCell
		
		if let reusableCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell {
			cell = reusableCell
		} else {
			cell = CustomCell(frame: .zero)
		}
		
		cell.dateLabel.text = cellState.text//formatter.string(from: date)
		
		return cell
	}
}

extension CalendarController: JTAppleCalendarViewDataSource {
	func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
		
		formatter.dateFormat = "yyyy MM dd"
		formatter.timeZone = Calendar.current.timeZone
		formatter.locale = Calendar.current.locale
		
		guard let startDate = formatter.date(from: "2017 01 01"), let endDate = formatter.date(from: "2017 12 31") else { fatalError() }
		
		let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
		return parameters
	}
}

class CustomCell: JTAppleCell {
	lazy var dateLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Label"
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupLayout() {
		contentView.addSubview(dateLabel)
		
		NSLayoutConstraint.activate([
			dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
			])
	}
}
