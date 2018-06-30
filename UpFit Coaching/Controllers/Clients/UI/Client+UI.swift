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
			appraisalTitle.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 45.0),
			appraisalTitle.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			appraisalTitle.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			appraisalLabel.topAnchor.constraint(equalTo: appraisalTitle.bottomAnchor, constant: 15.0),
			appraisalLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			appraisalLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			followUpButton.topAnchor.constraint(equalTo: appraisalLabel.bottomAnchor, constant: 45.0),
			followUpButton.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			followUpButton.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0)
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
		
		appraisalTitle = UI.titleLabel
		appraisalTitle.font = .boldSystemFont(ofSize: 20)
		appraisalTitle.text = "Appraisal"
		
		appraisalLabel = UI.bodyLabel
		appraisalLabel.numberOfLines = 2
		appraisalLabel.text = "Goal: Loose fat\n3 sessions by week"
		
		followUpButton = UI.roundButton
		followUpButton.titleText = "showFollowUpButton".localized
		followUpButton.addTarget(self, action: #selector(followUp), for: .touchUpInside)
		
		appraisalButton = UI.roundButton
		appraisalButton.addTarget(self, action: #selector(appraisal), for: .touchUpInside)
	}
	
	fileprivate func removeFullLayout() {
		NSLayoutConstraint.deactivate(getAppraisalConstraints())
		
		appraisalTitle.removeFromSuperview()
		appraisalLabel.removeFromSuperview()
		followUpButton.removeFromSuperview()
		
		appraisalButton.titleText = "newAppraisalButton".localized
		appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 45.0)
	}
	
	fileprivate func showFullLayout() {
		view.addSubview(appraisalTitle)
		view.addSubview(appraisalLabel)
		view.addSubview(followUpButton)
		
		appraisalButton.titleText = "showAppraisalButton".localized
		appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: followUpButton.bottomAnchor, constant: 15.0)
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
