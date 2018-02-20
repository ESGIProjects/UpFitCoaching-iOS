//
//  ConversationTableViewCell.swift
//  Coaching
//
//  Created by Jason Pierna on 19/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
	
	lazy var photoImageView: UIImageView = {
		let photoImageView = UIImageView()
		photoImageView.translatesAutoresizingMaskIntoConstraints = false
		photoImageView.layer.masksToBounds = true
		photoImageView.contentMode = .scaleAspectFill
		photoImageView.backgroundColor = .red
		return photoImageView
	}()
	
	lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		return nameLabel
	}()
	
	lazy var messageLabel: UILabel = {
		let messageLabel = UILabel()
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		return messageLabel
	}()
	
	lazy var dateLabel: UILabel = {
		let dateLabel = UILabel()
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		return dateLabel
	}()

    override func awakeFromNib() {
        super.awakeFromNib()

		accessoryType = .disclosureIndicator
		setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	private func setupLayout() {
		// Layout the photo
		addSubview(photoImageView)
		
		NSLayoutConstraint.activate([
			photoImageView.heightAnchor.constraint(equalToConstant: 45.0),
			photoImageView.widthAnchor.constraint(equalToConstant: 45.0),
			photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
			photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
			photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.0)
			])
		
		// Layout the name label
		
		// Layout the message label
		
		// Layout the date label
	}

}
