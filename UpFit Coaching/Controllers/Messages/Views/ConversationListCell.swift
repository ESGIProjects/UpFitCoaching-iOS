//
//  ConversationListCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell {
	
	var circleView: UIView!
	var circleLabel: UILabel!
	var nameLabel: UILabel!
	var messageLabel: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		if let circleView = aDecoder.decodeObject(forKey: "circleView") as? UIView {
			self.circleView = circleView
		}
		
		if let circleLabel = aDecoder.decodeObject(forKey: "circleLabel") as? UILabel {
			self.circleLabel = circleLabel
		}
		
		if let nameLabel = aDecoder.decodeObject(forKey: "nameLabel") as? UILabel {
			self.nameLabel = nameLabel
		}
		
		if let messageLabel = aDecoder.decodeObject(forKey: "messageLabel") as? UILabel {
			self.messageLabel = messageLabel
		}
	}
	
	override func encode(with aCoder: NSCoder) {
		super.encode(with: aCoder)
		aCoder.encode(circleView, forKey: "circleView")
		aCoder.encode(circleLabel, forKey: "circleLabel")
		aCoder.encode(nameLabel, forKey: "nameLabel")
		aCoder.encode(messageLabel, forKey: "messageLabel")
	}
	
	// MARK: - Layout
	
	private func getConstraints() -> [NSLayoutConstraint] {
		let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 66.0)
		heightConstraint.priority = UILayoutPriority(rawValue: 999)
		
		return [
			heightConstraint,
			
			circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.0),
			circleView.heightAnchor.constraint(equalToConstant: 50.0),
			circleView.widthAnchor.constraint(equalToConstant: 50.0),
			
			circleLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
			circleLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
			
			nameLabel.topAnchor.constraint(equalTo: circleView.topAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8.0),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
			
			messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2.0),
			messageLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8.0),
			messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
			messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8.0)
		]
	}
	
	private func setUIComponents() {
		circleView = UIImageView(frame: .zero)
		circleView.translatesAutoresizingMaskIntoConstraints = false
		circleView.layer.masksToBounds = true
		circleView.backgroundColor = UIColor(red: 17.0/255.0, green: 142.0/255.0, blue: 135.0/255.0, alpha: 1.0)
		circleView.layer.cornerRadius = 25.0
		
		circleLabel = UILabel()
		circleLabel.translatesAutoresizingMaskIntoConstraints = false
		circleLabel.textColor = .white
		circleLabel.font = .boldSystemFont(ofSize: 22.0)
		
		nameLabel = UILabel()
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		
		messageLabel = UILabel()
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
		messageLabel.numberOfLines = 2
		messageLabel.textColor = .gray
	}
	
	private func setupLayout() {
		setUIComponents()
		
		contentView.addSubview(circleView)
		contentView.addSubview(circleLabel)
		contentView.addSubview(nameLabel)
		contentView.addSubview(messageLabel)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
