//
//  CustomCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
	
	var selectedBackground: UIView!
	var eventIndicatorView: UIView!
	var dateLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUIComponents() {
		selectedBackground = UIView()
		selectedBackground.translatesAutoresizingMaskIntoConstraints = false
		selectedBackground.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.4941176471, blue: 0.8745098039, alpha: 1)
		selectedBackground.layer.cornerRadius = 15.0
		selectedBackground.isHidden = true
		
		eventIndicatorView = UIView()
		eventIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		eventIndicatorView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.4941176471, blue: 0.8745098039, alpha: 1)
		eventIndicatorView.layer.cornerRadius = 2.0
		eventIndicatorView.isHidden = true
		
		dateLabel = UILabel(frame: .zero)
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func setupLayout() {
		setUIComponents()
		
		contentView.addSubview(selectedBackground)
		contentView.addSubview(dateLabel)
		contentView.addSubview(eventIndicatorView)
		
		NSLayoutConstraint.activate([
			selectedBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			selectedBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			selectedBackground.heightAnchor.constraint(equalToConstant: 30.0),
			selectedBackground.widthAnchor.constraint(equalToConstant: 30.0),
			
			dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			eventIndicatorView.topAnchor.constraint(equalTo: selectedBackground.bottomAnchor, constant: 3.0),
			eventIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			eventIndicatorView.heightAnchor.constraint(equalToConstant: 4.0),
			eventIndicatorView.widthAnchor.constraint(equalToConstant: 4.0)
			])
	}
}
