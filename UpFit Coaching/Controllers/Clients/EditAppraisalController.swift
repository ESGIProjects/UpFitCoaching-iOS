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
	var totalSessionsByWeekRow: StepperRow!
	var contraindicationRow: TextRow!
	var sportsAntecedentsRow: TextRow!
	var helpNeededRow: SwitchRow!
	var hasNutritionistRow: SwitchRow!
	var commentsRow: TextAreaRow!
	
	var editionMode = EditionMode.add
//	var appraisal: Appraisal?
	
	var client: User?
	var goal: String!
	var totalSessionsByWeek: Int!
	var contraindication: String!
	var sportsAntecedents: String!
	var helpNeeded: Bool!
	var hasNutritionist: Bool!
	var comments: String!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if editionMode == .add {
			title = "editAppraiseController_addTitle".localized
			
			goal = ""
			totalSessionsByWeek = 0
			contraindication = ""
			sportsAntecedents = ""
			helpNeeded = false
			hasNutritionist = false
			comments = ""
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(confirm))
		} else {
			title = "editAppraiseController_editTitle".localized
			
//			guard let appraisal = appraisal else { return }
			
			goal = ""
			totalSessionsByWeek = 0
			contraindication = ""
			sportsAntecedents = ""
			helpNeeded = false
			hasNutritionist = false
			comments = ""
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirm))
		}
		
		setupLayout()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toggleConfirmationButton()
	}
	
	// MARK: - Actions
	
	@objc func confirm() {
		
	}
	
	@objc func cancel() {
		
	}
	
	// MARK: - Helpers
	
	func add() {
		
	}
	
	func update() {
		
	}
	
	func toggleConfirmationButton() {
		
	}
}
