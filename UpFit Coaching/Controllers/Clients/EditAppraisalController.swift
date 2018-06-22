//
//  EditAppraisalController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 18/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class EditAppraisalController: FormViewController {
	var goalRow: TextRow!
	var sessionsByWeekRow: StepperRow!
	var contraindicationRow: TextRow!
	var sportAntecedentsRow: TextRow!
	var helpNeededRow: SwitchRow!
	var hasNutritionistRow: SwitchRow!
	var commentsRow: TextAreaRow!
	
	var editionMode = EditionMode.add
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
		
		if editionMode == .add {
			goal = ""
			sessionsByWeek = 0
			contraindication = ""
			sportAntecedents = ""
			helpNeeded = false
			hasNutritionist = false
			comments = ""
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(confirm))
		} else {
			guard let appraisal = appraisal else { return }
			
			goal = appraisal.goal
			sessionsByWeek = appraisal.sessionsByWeek
			contraindication = appraisal.contraindication
			sportAntecedents = appraisal.sportAntecedents
			helpNeeded = appraisal.helpNeeded
			hasNutritionist = appraisal.hasNutritionist
			comments = appraisal.comments
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirm))
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
		
		// Network & save
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	func toggleConfirmationButton() {
		navigationItem.rightBarButtonItem?.isEnabled = goal != ""
	}
}
