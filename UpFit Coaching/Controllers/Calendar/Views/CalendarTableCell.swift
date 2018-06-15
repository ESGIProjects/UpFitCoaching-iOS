//
//  CalendarTableCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class CalendarTableCell: UITableViewCell {
	var iconImageView: UIImageView!
	var titleLabel: UILabel!
	var infoLabel: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func getConstraints() -> [NSLayoutConstraint] {
		let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0)
		heightConstraint.priority = UILayoutPriority(rawValue: 999)

		return [
			heightConstraint,

			iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			iconImageView.widthAnchor.constraint(equalToConstant: 50.0),
			iconImageView.heightAnchor.constraint(equalToConstant: 50.0),

			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
			titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10.0),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),

			infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
			infoLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10.0),
			infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
			infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
		]
	}
	
	private func setUIComponents() {
		iconImageView = UIImageView(frame: .zero)
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel = UILabel(frame: .zero)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .boldSystemFont(ofSize: 15)
		
		infoLabel = UILabel(frame: .zero)
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.font = .systemFont(ofSize: 13)
		infoLabel.textColor = .gray
		infoLabel.numberOfLines = 2
	}
	
	private func setupLayout() {
		setUIComponents()
		
		contentView.addSubview(iconImageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(infoLabel)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
