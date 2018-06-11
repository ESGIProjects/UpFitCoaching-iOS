//
//  ThreadCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ThreadCell: UITableViewCell {
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
		return [
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
			infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0)
		]
	}
	
	private func setUIComponents() {
		titleLabel = UILabel(frame: .zero)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.numberOfLines = 2
		titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
		
		infoLabel = UILabel(frame: .zero)
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.numberOfLines = 2
		infoLabel.font = UIFont.systemFont(ofSize: 15)
		infoLabel.textColor = .gray
	}
	
	private func setupLayout() {
		setUIComponents()
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(infoLabel)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
