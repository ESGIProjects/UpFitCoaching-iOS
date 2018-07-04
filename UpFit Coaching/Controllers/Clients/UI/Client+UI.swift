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
			scrollView.topAnchor.constraint(equalTo: anchors.top),
			scrollView.leadingAnchor.constraint(equalTo: anchors.leading),
			scrollView.trailingAnchor.constraint(equalTo: anchors.trailing),
			scrollView.bottomAnchor.constraint(equalTo: anchors.bottom),
			
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			
			contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
			
			nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0),
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			birthDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15.0),
			birthDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			birthDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			cityLabel.topAnchor.constraint(equalTo: birthDateLabel.bottomAnchor, constant: 15.0),
			cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			callButton.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 15.0),
			callButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			
			mailButton.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 15.0),
			mailButton.leadingAnchor.constraint(equalTo: callButton.trailingAnchor, constant: 15.0),
			mailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			mailButton.widthAnchor.constraint(equalTo: callButton.widthAnchor),
			
			appraisalButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			appraisalButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0)
		]
	}
	
	fileprivate func getAppraisalConstraints() -> [NSLayoutConstraint] {
		return [
			appraisalTitle.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 20.0),
			appraisalTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			appraisalTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			appraisalLabel.topAnchor.constraint(equalTo: appraisalTitle.bottomAnchor, constant: 15.0),
			appraisalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			appraisalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			followUpButton.topAnchor.constraint(equalTo: appraisalLabel.bottomAnchor, constant: 20.0),
			followUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			followUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			testTitle.topAnchor.constraint(equalTo: appraisalButton.bottomAnchor, constant: 20.0),
			testTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			testTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			testLabel.topAnchor.constraint(equalTo: testTitle.bottomAnchor, constant: 15.0),
			testLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			testLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			testButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			testButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
			
			prescriptionButton.topAnchor.constraint(equalTo: testButton.bottomAnchor, constant: 15.0),
			prescriptionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
			prescriptionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0)
		]
	}
	
	fileprivate func setUIComponents() {
		scrollView = UI.genericScrollView
		contentView = UI.genericView
		
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
		appraisalTitle.text = "appraisalTitle".localized
		
		appraisalLabel = UI.bodyLabel
		appraisalLabel.numberOfLines = 2
		
		followUpButton = UI.roundButton
		followUpButton.titleText = "showFollowUpButton".localized
		followUpButton.addTarget(self, action: #selector(followUp), for: .touchUpInside)
		
		appraisalButton = UI.roundButton
		appraisalButton.addTarget(self, action: #selector(appraisal), for: .touchUpInside)
		
		testTitle = UI.titleLabel
		testTitle.font = .boldSystemFont(ofSize: 20)
		testTitle.text = "lastTestTitle".localized
		
		testLabel = UI.bodyLabel
		testLabel.numberOfLines = 2
		
		testButton = UI.roundButton
		testButton.titleText = "testButton".localized
		testButton.addTarget(self, action: #selector(test), for: .touchUpInside)
		
		prescriptionButton = UI.roundButton
		prescriptionButton.titleText = "prescriptionButton".localized
		prescriptionButton.addTarget(self, action: #selector(prescription), for: .touchUpInside)
	}
	
	fileprivate func removeFullLayout() {
		removeTestLayout()
		
		NSLayoutConstraint.deactivate(getAppraisalConstraints())
		
		appraisalTitle.removeFromSuperview()
		appraisalLabel.removeFromSuperview()
		followUpButton.removeFromSuperview()
		testButton.removeFromSuperview()
		prescriptionButton.removeFromSuperview()
		testTitle.removeFromSuperview()
		testLabel.removeFromSuperview()
		
		appraisalButton.titleText = "newAppraisalButton".localized
		appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 45.0)
		contentBottomConstraint = appraisalButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15.0)
		
		showsFullLayout = false
	}
	
	fileprivate func showFullLayout(test: Bool) {
		contentView.addSubview(appraisalTitle)
		contentView.addSubview(appraisalLabel)
		contentView.addSubview(followUpButton)
		contentView.addSubview(testButton)
		contentView.addSubview(prescriptionButton)
		contentView.addSubview(testTitle)
		contentView.addSubview(testLabel)
		
		appraisalButton.titleText = "showAppraisalButton".localized
		appraisalTopConstraint = appraisalButton.topAnchor.constraint(equalTo: followUpButton.bottomAnchor, constant: 15.0)
		testTopConstraint = testButton.topAnchor.constraint(equalTo: appraisalButton.bottomAnchor, constant: 15.0)
		contentBottomConstraint = prescriptionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15.0)
		NSLayoutConstraint.activate(getAppraisalConstraints())
		
		showsFullLayout = true
		
		if test {
			showTestLayout()
		} else {
			removeTestLayout()
		}
	}
	
	fileprivate func showTestLayout() {
		testTopConstraint = testButton.topAnchor.constraint(equalTo: testLabel.bottomAnchor, constant: 15.0)
		
		testTitle.isHidden = false
		testLabel.isHidden = false
		
		showsTestLayout = true
	}
	
	fileprivate func removeTestLayout() {
		testTopConstraint = testButton.topAnchor.constraint(equalTo: appraisalButton.bottomAnchor, constant: 15.0)
		
		testTitle.isHidden = true
		testLabel.isHidden = true
		
		showsTestLayout = false
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(nameLabel)
		contentView.addSubview(birthDateLabel)
		contentView.addSubview(cityLabel)
		contentView.addSubview(callButton)
		contentView.addSubview(mailButton)
		contentView.addSubview(appraisalButton)
		
		NSLayoutConstraint.activate(getConstraints())
		
		removeFullLayout()
		appraisalTopConstraint.isActive = true
		contentBottomConstraint.isActive = true
	}
	
	func refreshLayout() {
		// Manipulate what should be removed and added on viewWillAppear
		
		guard let client = client else { return }
		
		let database = Database()
		let lastAppraisal = database.getLastAppraisal(for: client)
		let lastTest = database.getLastTest(for: client)
		
		appraisalTopConstraint.isActive = false
		contentBottomConstraint.isActive = false
		
		if !showsFullLayout && lastAppraisal != nil {
			showFullLayout(test: lastTest != nil)
		}
		
		if showsFullLayout && lastAppraisal == nil {
			removeFullLayout()
		}
		
		if showsFullLayout {
			testTopConstraint.isActive = false
			
			if !showsTestLayout && lastTest != nil {
				showTestLayout()
			} else if showsTestLayout && lastTest == nil {
				removeTestLayout()
			}
			
			testTopConstraint.isActive = true
		}
		
		appraisalTopConstraint.isActive = true
		contentBottomConstraint.isActive = true
	}
}
