//
//  ConversationListCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell {
	
	var photoImageView: UIImageView!
	var nameLabel: UILabel!
	var messageLabel: UILabel!
	var dateLabel: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		if let nameLabel = aDecoder.decodeObject(forKey: "nameLabel") as? UILabel {
			self.nameLabel = nameLabel
		}
		
		if let messageLabel = aDecoder.decodeObject(forKey: "messageLabel") as? UILabel {
			self.messageLabel = messageLabel
		}
		
		if let dateLabel = aDecoder.decodeObject(forKey: "dateLabel") as? UILabel {
			self.dateLabel = dateLabel
		}
	}
	
	override func encode(with aCoder: NSCoder) {
		super.encode(with: aCoder)
		aCoder.encode(nameLabel, forKey: "nameLabel")
		aCoder.encode(messageLabel, forKey: "messageLabel")
		aCoder.encode(dateLabel, forKey: "dateLabel")
	}
	
	// MARK: - Layout
	
	private func getConstraints() -> [NSLayoutConstraint] {
		let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 66.0)
		heightConstraint.priority = UILayoutPriority(rawValue: 999)
		
		return [
			heightConstraint,
			
			photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.0),
			photoImageView.heightAnchor.constraint(equalToConstant: 50.0),
			photoImageView.widthAnchor.constraint(equalToConstant: 50.0),
			
			nameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8.0),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
			
			messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2.0),
			messageLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8.0),
			messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
			messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8.0)
		]
	}
	
	private func setUIComponents() {
		photoImageView = UIImageView(frame: .zero)
		photoImageView.translatesAutoresizingMaskIntoConstraints = false
		photoImageView.layer.masksToBounds = true
		photoImageView.backgroundColor = tintColor
		photoImageView.layer.cornerRadius = 25.0
		
		nameLabel = UILabel()
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		
		messageLabel = UILabel()
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
		messageLabel.numberOfLines = 2
		messageLabel.textColor = .gray
		
		dateLabel = UILabel()
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.textColor = .gray
	}
	
	private func setupLayout() {
		setUIComponents()
		
		contentView.addSubview(photoImageView)
		contentView.addSubview(nameLabel)
		contentView.addSubview(messageLabel)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
