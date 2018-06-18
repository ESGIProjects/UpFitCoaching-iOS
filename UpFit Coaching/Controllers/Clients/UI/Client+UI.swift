//
//  Client+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ClientController {
	class UI {
		class func nameLabel() -> UILabel {
			let label = UILabel(frame: .zero)
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.font = .preferredFont(forTextStyle: .title1)
			label.numberOfLines = 2
			
			return label
		}
		
		class func birthDateLabel() -> UILabel {
			let label = UILabel(frame: .zero)
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.font = .preferredFont(forTextStyle: .headline)
			label.textColor = .gray
			label.numberOfLines = 2
			
			return label
		}
		
		class func cityLabel() -> UILabel {
			let label = UILabel(frame: .zero)
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.font = .preferredFont(forTextStyle: .headline)
			label.textColor = .gray
			
			return label
		}
		
		class func callButton() -> UIButton {
			let button = UIButton(frame: .zero)
			button.translatesAutoresizingMaskIntoConstraints = false
			
			button.setTitle("callButton".localized, for: .normal)
			button.backgroundColor = .main
			button.layer.cornerRadius = 5.0
			
			return button
		}
		
		class func mailButton() -> UIButton {
			let button = UIButton(frame: .zero)
			button.translatesAutoresizingMaskIntoConstraints = false
			
			button.setTitle("sendMailButton".localized, for: .normal)
			button.backgroundColor = .main
			button.layer.cornerRadius = 5.0
			
			return button
		}
		
		class func bilanButton() -> UIButton {
			let button = UIButton(frame: .zero)
			button.translatesAutoresizingMaskIntoConstraints = false
			
			button.setTitle("nouvelle_fiche_bilan", for: .normal)
			button.backgroundColor = .main
			button.layer.cornerRadius = 5.0
			
			return button
		}
	}
	
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			nameLabel.topAnchor.constraint(equalTo: anchors.top, constant: 15.0),
			nameLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			nameLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			birthDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15.0),
			birthDateLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			birthDateLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			cityLabel.topAnchor.constraint(equalTo: birthDateLabel.bottomAnchor, constant: 15.0),
			cityLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			cityLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			callButton.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 15.0),
			callButton.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			
			mailButton.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 15.0),
			mailButton.leadingAnchor.constraint(equalTo: callButton.trailingAnchor, constant: 15.0),
			mailButton.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			mailButton.widthAnchor.constraint(equalTo: callButton.widthAnchor),
			
			bilanButton.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 30.0),
			bilanButton.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			bilanButton.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0)
		]
	}
	
	fileprivate func setUIComponents() {
		nameLabel = UI.nameLabel()
		birthDateLabel = UI.birthDateLabel()
		cityLabel = UI.cityLabel()
		
		callButton = UI.callButton()
		callButton.addTarget(self, action: #selector(call), for: .touchUpInside)
		
		mailButton = UI.mailButton()
		mailButton.addTarget(self, action: #selector(mail), for: .touchUpInside)
		
		bilanButton = UI.bilanButton()
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(nameLabel)
		view.addSubview(birthDateLabel)
		view.addSubview(cityLabel)
		view.addSubview(callButton)
		view.addSubview(mailButton)
		view.addSubview(bilanButton)
		
		NSLayoutConstraint.activate(getConstraints())
	}
	
	func refreshLayout() {
		// Manipulate what should be removed and added on viewWillAppear
	}
}
