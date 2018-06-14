//
//  CalendarTableCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class CalendarTableCell: UITableViewCell {
//	var iconImageView: UIImageView!
	var separatorView: UIView!
	
	var titleLabel: UILabel!
	var infoLabel: UILabel!
	
	var startTimeLabel: UILabel!
	var endTimeLabel: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func getConstraints() -> [NSLayoutConstraint] {
		return [
			startTimeLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3.0),
			startTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
			startTimeLabel.widthAnchor.constraint(equalToConstant: 40),
			
			endTimeLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 3.0),
			endTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
			endTimeLabel.widthAnchor.constraint(equalTo: startTimeLabel.widthAnchor, multiplier: 1.0),
			
			separatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
			separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
			separatorView.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: 3.0),
			separatorView.widthAnchor.constraint(equalToConstant: 2.0),
			
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
			titleLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 5.0),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
			
			infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
			infoLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 5.0),
			infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5.0),
			infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
		]
	}
	
	private func setUIComponents() {
		separatorView = UIView()
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		separatorView.backgroundColor = .main
		
		titleLabel = UILabel(frame: .zero)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont.systemFont(ofSize: 15)
		
		infoLabel = UILabel(frame: .zero)
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.font = UIFont.systemFont(ofSize: 13)
		infoLabel.textColor = .gray
		
		startTimeLabel = UILabel(frame: .zero)
		startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		startTimeLabel.font = UIFont.systemFont(ofSize: 11)
		startTimeLabel.textAlignment = .center

		endTimeLabel = UILabel(frame: .zero)
		endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		endTimeLabel.font = UIFont.systemFont(ofSize: 11)
		endTimeLabel.textAlignment = .center
		endTimeLabel.textColor = .gray

	}
	
	private func setupLayout() {
		setUIComponents()
		
		contentView.addSubview(separatorView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(infoLabel)
		contentView.addSubview(startTimeLabel)
		contentView.addSubview(endTimeLabel)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
