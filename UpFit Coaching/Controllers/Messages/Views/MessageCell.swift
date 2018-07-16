//
//  MessageCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

class MessageCell: UICollectionViewCell {
	
	var messageLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		if let messageLabel = aDecoder.decodeObject(forKey: "messageLabel") as? UILabel {
			self.messageLabel = messageLabel
		}
	}
	
	override func encode(with aCoder: NSCoder) {
		super.encode(with: aCoder)
		aCoder.encode(messageLabel, forKey: "messageLabel")
	}
	
	func setupLayout() {
		contentView.layer.cornerRadius = 15.0
		contentView.layer.masksToBounds = true
		
		messageLabel = UILabel()
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.numberOfLines = 0
		messageLabel.lineBreakMode = .byWordWrapping
		messageLabel.textColor = .white
		
		contentView.addSubview(messageLabel)

		NSLayoutConstraint.activate([
			messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
			messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
			messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0)
			])
	}
}
