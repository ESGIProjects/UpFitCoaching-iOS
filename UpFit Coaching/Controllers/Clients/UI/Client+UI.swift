//
//  Client+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ClientController {
	class UICC {
		
		// MARK: - Labels
		
		static var genericLabel: UILabel {
			let label = UILabel(frame: .zero)
			label.translatesAutoresizingMaskIntoConstraints = false
			
			return label
		}
		
		static var titleLabel: UILabel {
			let label = UICC.genericLabel
			label.font = .preferredFont(forTextStyle: .title1)

			return label
		}
		
		static var headlineLabel: UILabel {
			let label = UICC.genericLabel
			label.font = .preferredFont(forTextStyle: .headline)
			label.textColor = .gray

			return label
		}
		
		// MARK: - Buttons
		
		static var genericButton: UIButton {
			let button = UIButton(frame: .zero)
			button.translatesAutoresizingMaskIntoConstraints = false
			
			return button
		}
		
		static var roundButton: UIButton {
			let button = UICC.genericButton
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
		nameLabel = UICC.titleLabel
		nameLabel.numberOfLines = 2
		
		birthDateLabel = UICC.headlineLabel
		birthDateLabel.numberOfLines = 2
		
		cityLabel = UICC.headlineLabel
		
		callButton = UICC.roundButton
		callButton.titleText = "callButton".localized
		callButton.addTarget(self, action: #selector(call), for: .touchUpInside)
		
		mailButton = UICC.roundButton
		mailButton.titleText = "sendMailButton".localized
		mailButton.addTarget(self, action: #selector(mail), for: .touchUpInside)
		
		followUpButton = UICC.roundButton
		followUpButton.titleText = "showFollowUpButton".localized
		
		appraisalButton = UICC.roundButton
		appraisalButton.addTarget(self, action: #selector(newAppraisal), for: .touchUpInside)
		
		measurementsButton = UICC.roundButton
		measurementsButton.titleText = "measurementsButton".localized
		measurementsButton.addTarget(self, action: #selector(updateMeasurements), for: .touchUpInside)
		
		testButton = UICC.roundButton
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
