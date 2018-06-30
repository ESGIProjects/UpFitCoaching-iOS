//
//  UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 23/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import MapKit
import JTAppleCalendar
import Charts

class UI {
	// MARK: - Labels
	
	static var genericLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}
	
	static var titleLabel: UILabel {
		let label = genericLabel
		label.font = .preferredFont(forTextStyle: .title1)
		
		return label
	}
	
	static var headlineLabel: UILabel {
		let label = genericLabel
		label.font = .preferredFont(forTextStyle: .headline)
		label.textColor = .gray
		
		return label
	}
	
	static var bodyLabel: UILabel {
		let label = genericLabel
		label.font = .preferredFont(forTextStyle: .body)
		
		return label
	}
	
	// MARK: - Buttons
	
	static var genericButton: UIButton {
		let button = UIButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}
	
	static var roundButton: UIButton {
		let button = genericButton
		button.titleColor = .main
		button.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
		button.layer.cornerRadius = 5.0
		
		return button
	}
	
	// MARK: - Text fields
	
	static var genericTextField: UITextField {
		let textField = UITextField(frame: .zero)
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		return textField
	}
	
	static var roundedTextField: UITextField {
		let textField = genericTextField
		textField.borderStyle = .roundedRect
		
		return textField
	}
	
	// MARK: - Views
	
	static var genericView: UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}
	
	static var genericScrollView: UIScrollView {
		let view = UIScrollView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.keyboardDismissMode = .interactive
		
		return view
	}
	
	static var genericTableView: UITableView {
		let view = UITableView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}
	
	static var messageBar: MessageBarView {
		let messageBarView = MessageBarView()
		messageBarView.translatesAutoresizingMaskIntoConstraints = false
		messageBarView.placeholder = "message_placeholder".localized
		messageBarView.button.titleText = "sendMessage_button".localized
		messageBarView.button.titleColor = .main
		messageBarView.button.titleFont = .boldSystemFont(ofSize: 17.0)
		
		return messageBarView
	}
	
	static var calendarWeekdaysHeader: UIStackView {
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
	
	static var eventMap: MKMapView {
		let view = MKMapView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.borderColor = UIColor.lightGray.cgColor
		view.layer.borderWidth = 1.0
		view.layer.cornerRadius = 5.0
		view.layer.masksToBounds = true
		view.isScrollEnabled = false
		view.isZoomEnabled = false
		view.isHidden = true
		
		return view
	}
	
	// MARK: - Calendar
	
	static var genericCalendar: JTAppleCalendarView {
		let view = JTAppleCalendarView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.scrollDirection = .horizontal
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.scrollingMode = .stopAtEachSection
		view.isPagingEnabled = true
		view.backgroundColor = .background
		
		return view
	}
	
	// MARK: - Chart
	
	static var genericLineChart: LineChartView {
		let view = LineChartView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.chartDescription = nil
		view.drawGridBackgroundEnabled = false
		view.legend.enabled = false
		
		return view
	}
}
