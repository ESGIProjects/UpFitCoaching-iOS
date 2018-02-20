//
//  ConversationListCell.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell {
	
	lazy var photoImageView: UIImageView = {
		let photoImageView = UIImageView(frame: .zero)
		photoImageView.translatesAutoresizingMaskIntoConstraints = false
		photoImageView.layer.masksToBounds = true
		photoImageView.backgroundColor = .red
		return photoImageView
	}()
	
	lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		return nameLabel
	}()
	
	lazy var messageLabel: UILabel = {
		let messageLabel = UILabel()
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
		messageLabel.numberOfLines = 2
		messageLabel.textColor = .gray
		return messageLabel
	}()
	
	lazy var dateLabel: UILabel = {
		let dateLabel = UILabel()
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.textColor = .gray
		return dateLabel
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		nameLabel = aDecoder.decodeObject(forKey: "nameLabel") as! UILabel
		messageLabel = aDecoder.decodeObject(forKey: "messageLabel") as! UILabel
		dateLabel = aDecoder.decodeObject(forKey: "dateLabel") as! UILabel
	}
	
	override func encode(with aCoder: NSCoder) {
		super.encode(with: aCoder)
		aCoder.encode(nameLabel, forKey: "nameLabel")
		aCoder.encode(messageLabel, forKey: "messageLabel")
		aCoder.encode(dateLabel, forKey: "dateLabel")
	}
	
	private func setupLayout() {
		contentView.addSubview(photoImageView)
		contentView.addSubview(nameLabel)
		contentView.addSubview(messageLabel)
		
		NSLayoutConstraint.activate([
			photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.0),
			photoImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8.0),
			photoImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8.0),
			photoImageView.heightAnchor.constraint(equalToConstant: 50),
			photoImageView.widthAnchor.constraint(equalToConstant: 50),
			
			nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
			nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8.0),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
			
			messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2.0),
			messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8.0),
			messageLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8.0),
			messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
			])
		
		photoImageView.layer.cornerRadius = 25
	}
}
