//
//  MessageCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
	
	var messageLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.layer.cornerRadius = 15.0
		contentView.layer.masksToBounds = true
		
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupLayout() {
		contentView.addSubview(messageLabel)

		NSLayoutConstraint.activate([
			messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
			messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
			messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0)
			])
	}
}
