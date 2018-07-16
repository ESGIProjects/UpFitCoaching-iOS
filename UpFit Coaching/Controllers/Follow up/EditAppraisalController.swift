//
//  EditAppraisalController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 18/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka
import PKHUD

class EditAppraisalController: FormViewController {
	var goalRow: TextRow!
	var sessionsByWeekRow: StepperRow!
	var contraindicationRow: TextRow!
	var sportAntecedentsRow: TextRow!
	var helpNeededRow: SwitchRow!
	var hasNutritionistRow: SwitchRow!
	var commentsRow: TextAreaRow!
	
	var appraisal: Appraisal?
	
	var client: User?
	var goal: String!
	var sessionsByWeek: Int!
	var contraindication: String!
	var sportAntecedents: String!
	var helpNeeded: Bool!
	var hasNutritionist: Bool!
	var comments: String!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let appraisal = appraisal {
			goal = appraisal.goal
			sessionsByWeek = appraisal.sessionsByWeek
			contraindication = appraisal.contraindication
			sportAntecedents = appraisal.sportAntecedents
			helpNeeded = appraisal.helpNeeded
			hasNutritionist = appraisal.hasNutritionist
			comments = appraisal.comments
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirm))
		} else {
			goal = ""
			sessionsByWeek = 0
			contraindication = ""
			sportAntecedents = ""
			helpNeeded = false
			hasNutritionist = false
			comments = ""
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(confirm))
		}
		
		title = "editAppraisalController_title".localized
		setupLayout()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toggleConfirmationButton()
	}
	
	// MARK: - Actions
	
	@objc func confirm() {
		guard let client = client else { return }
		let appraisal = Appraisal(user: client, date: Date(), goal: goal, sessionsByWeek: sessionsByWeek, contraindication: contraindication, sportAntecedents: sportAntecedents, helpNeeded: helpNeeded, hasNutritionist: hasNutritionist, comments: comments)
		
		HUD.show(.progress)
		
		Network.postAppraisal(appraisal) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 201) {
				// Unserialize appraisal id
				guard let appraisalID = self?.unserialize(data) else { return }
				
				// Update & save appraisal in DB
				appraisal.appraisalID = appraisalID
				Database().createOrUpdate(model: appraisal, with: AppraisalObject.init)
				
				DispatchQueue.main.async {
					self?.navigationController?.dismiss(animated: true)
				}
			} else {
				Network.displayError(self, from: data)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	func toggleConfirmationButton() {
		navigationItem.rightBarButtonItem?.isEnabled = goal != ""
	}
	
	private func unserialize(_ data: Data) -> Int? {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
		guard let json = unserializedJSON as? [String: Int] else { return nil }
		
		guard let appraisalId = json["id"] else { return nil }
		
		return appraisalId
	}
}
