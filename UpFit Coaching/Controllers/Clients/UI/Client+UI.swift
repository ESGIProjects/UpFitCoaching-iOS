//
//  Client+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ClientController {
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
		nameLabel = UI.titleLabel
		nameLabel.numberOfLines = 2
		
		birthDateLabel = UI.headlineLabel
		birthDateLabel.numberOfLines = 2
		
		cityLabel = UI.headlineLabel
		
		callButton = UI.roundButton
		callButton.titleText = "callButton".localized
		callButton.addTarget(self, action: #selector(call), for: .touchUpInside)
		
		mailButton = UI.roundButton
		mailButton.titleText = "sendMailButton".localized
		mailButton.addTarget(self, action: #selector(mail), for: .touchUpInside)
		
		followUpButton = UI.roundButton
		followUpButton.titleText = "showFollowUpButton".localized
		
		appraisalButton = UI.roundButton
		appraisalButton.addTarget(self, action: #selector(newAppraisal), for: .touchUpInside)
		
		measurementsButton = UI.roundButton
		measurementsButton.titleText = "measurementsButton".localized
		measurementsButton.addTarget(self, action: #selector(updateMeasurements), for: .touchUpInside)
		
		testButton = UI.roundButton
		testButton.titleText = "newTestButton".localized
		testButton.addTarget(self, action: #selector(newTest), for: .touchUpInside)
	}
	
	fileprivate func removeFullLayout() {
		NSLayoutConstraint.deactivate(getAppraisalConstraints())
		
		followUpButton.removeFromSuperview()
		measurementsButton.removeFromSuperview()
		testButton.removeFromSuperview()
		
		appraisalButton.titleText = "newAppraisalButton".localized
		appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 45.0)
	}
	
	fileprivate func showFullLayout() {
		view.addSubview(followUpButton)
		view.addSubview(measurementsButton)
		view.addSubview(testButton)
		
		appraisalButton.titleText = "showAppraisalButton".localized
		appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: followUpButton.bottomAnchor, constant: 45.0)
		NSLayoutConstraint.activate(getAppraisalConstraints())
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(nameLabel)
		view.addSubview(birthDateLabel)
		view.addSubview(cityLabel)
		view.addSubview(callButton)
		view.addSubview(mailButton)
		view.addSubview(appraisalButton)
		
		NSLayoutConstraint.activate(getConstraints())
		
		removeFullLayout()
		appraisalTopConstraint.isActive = true
	}
	
	func refreshLayout() {
		// Manipulate what should be removed and added on viewWillAppear
		
		guard let client = client else { return }
		let lastAppraisal = Database().getLastAppraisal(for: client)
		
		appraisalTopConstraint.isActive = false
		
		if !showsFullLayout && lastAppraisal != nil {
			showFullLayout()
		}
		
		if showsFullLayout && lastAppraisal == nil {
			removeFullLayout()
		}
		
		appraisalTopConstraint.isActive = true
	}
}
