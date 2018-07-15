//
//  PostCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
	var leftView: UIView!
	var userNameLabel: UILabel!
	var dateLabel: UILabel!
	var contentLabel: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func getConstraints() -> [NSLayoutConstraint] {
		return [
			leftView.topAnchor.constraint(equalTo: contentView.topAnchor),
			leftView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			leftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			leftView.widthAnchor.constraint(equalToConstant: 5.0),
			
			userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
			userNameLabel.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 5.0),
			
			dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
			dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
			dateLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 5.0),
			
			contentLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5.0),
			contentLabel.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 5.0),
			contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
			contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
		]
	}
	
	private func setUIComponents() {
		leftView = UIView(frame: .zero)
		leftView.translatesAutoresizingMaskIntoConstraints = false
		leftView.backgroundColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
		
		userNameLabel = UILabel(frame: .zero)
		userNameLabel.translatesAutoresizingMaskIntoConstraints = false
		userNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
		userNameLabel.textColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
		
		dateLabel = UILabel(frame: .zero)
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.font = UIFont.systemFont(ofSize: 13)
		dateLabel.textAlignment = .right
		dateLabel.textColor = .gray
		
		contentLabel = UILabel(frame: .zero)
		contentLabel.translatesAutoresizingMaskIntoConstraints = false
		contentLabel.font = UIFont.systemFont(ofSize: 14)
		contentLabel.numberOfLines = 0
	}
	
	private func setupLayout() {
		setUIComponents()
		
		contentView.addSubview(leftView)
		contentView.addSubview(userNameLabel)
		contentView.addSubview(dateLabel)
		contentView.addSubview(contentLabel)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
