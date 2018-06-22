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
		
		class func followUpButton() -> UIButton {
			let button = UIButton(frame: .zero)
			button.translatesAutoresizingMaskIntoConstraints = false
			
			button.setTitle("showFollowUpButton".localized, for: .normal)
			button.backgroundColor = .main
			button.layer.cornerRadius = 5.0
			
			return button
		}
		
		class func appraisalButton() -> UIButton {
			let button = UIButton(frame: .zero)
			button.translatesAutoresizingMaskIntoConstraints = false
			
			button.backgroundColor = .main
			button.layer.cornerRadius = 5.0
			
			return button
		}
		
		class func measurementsButton() -> UIButton {
			let button = UIButton(frame: .zero)
			button.translatesAutoresizingMaskIntoConstraints = false
			
			button.setTitle("measurementsButton".localized, for: .normal)
			button.backgroundColor = .main
			button.layer.cornerRadius = 5.0
			
			return button
		}
		
		class func testButton() -> UIButton {
			let button = UIButton(frame: .zero)
			button.translatesAutoresizingMaskIntoConstraints = false
			
			button.setTitle("newTestButton".localized, for: .normal)
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
			
			appraisalButton.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			appraisalButton.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0)
		]
	}
	
	fileprivate func getAppraisalConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			followUpButton.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 45.0),
			followUpButton.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			followUpButton.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			measurementsButton.topAnchor.constraint(equalTo: appraisalButton.bottomAnchor, constant: 15.0),
			measurementsButton.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			measurementsButton.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			testButton.topAnchor.constraint(equalTo: measurementsButton.bottomAnchor, constant: 15.0),
			testButton.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			testButton.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0)
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
		
		followUpButton = UI.followUpButton()
		appraisalButton = UI.appraisalButton()
		appraisalButton.addTarget(self, action: #selector(newAppraisal), for: .touchUpInside)
		
		measurementsButton = UI.measurementsButton()
		measurementsButton.addTarget(self, action: #selector(updateMeasurements), for: .touchUpInside)
		
		testButton = UI.testButton()
		testButton.addTarget(self, action: #selector(newTest), for: .touchUpInside)
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(nameLabel)
		view.addSubview(birthDateLabel)
		view.addSubview(cityLabel)
		view.addSubview(callButton)
		view.addSubview(mailButton)
		view.addSubview(appraisalButton)
		
		var constraints = getConstraints()
		
		guard let client = client else { return }
		
		if Database().getLastAppraisal(for: client) != nil {
			view.addSubview(followUpButton)
			view.addSubview(measurementsButton)
			view.addSubview(testButton)
			
			appraisalButton.setTitle("showAppraisalButton".localized, for: .normal)
			
			constraints += getAppraisalConstraints()
			appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: followUpButton.bottomAnchor, constant: 45.0)

		} else {
			appraisalButton.setTitle("newAppraisalButton".localized, for: .normal)
			appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 45.0)
		}
		
		constraints.append(appraisalTopConstraint)
		NSLayoutConstraint.activate(constraints)
	}
	
	func refreshLayout() {
		// Manipulate what should be removed and added on viewWillAppear
		guard let secondAnchor = appraisalTopConstraint.secondAnchor else { return }
		
		appraisalTopConstraint.isActive = false
		
		if secondAnchor == callButton.bottomAnchor {
			view.addSubview(followUpButton)
			view.addSubview(measurementsButton)
			view.addSubview(testButton)
			
			appraisalButton.setTitle("showAppraisalButton".localized, for: .normal)
			
			appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: followUpButton.bottomAnchor, constant: 45.0)
			NSLayoutConstraint.activate(getAppraisalConstraints())
		} else {
			NSLayoutConstraint.deactivate(getAppraisalConstraints())
			
			followUpButton.removeFromSuperview()
			measurementsButton.removeFromSuperview()
			testButton.removeFromSuperview()
			
			appraisalButton.setTitle("newAppraisalButton".localized, for: .normal)
			
			appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 45.0)
		}
		
		appraisalTopConstraint.isActive = true
	}
}
