//
//  EditAppraisal+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 18/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

extension EditAppraisalController {
	fileprivate func setUIComponents() {
		goalRow = TextRow("goal") {
			$0.title = "appraisalGoal_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = goal
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.goal = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		sessionsByWeekRow = StepperRow("sessionsByWeek") {
			$0.title = "appraisalSessionsByWeek_fieldTitle".localized
			$0.value = Double(sessionsByWeek)
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.sessionsByWeek = Int(value)
					self.toggleConfirmationButton()
				}
			}
		}
		
		contraindicationRow = TextRow("contraindication") {
			$0.title = "appraisalContraindication_fieldTitle".localized
			$0.placeholder = "optionalField".localized
			$0.value = contraindication
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.contraindication = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		sportAntecedentsRow = TextRow("sportAntecedents") {
			$0.title = "appraisalSportAntecedents_fieldTitle".localized
			$0.placeholder = "optionalField".localized
			$0.value = sportAntecedents
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.sportAntecedents = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		helpNeededRow = SwitchRow("helpNeeded") {
			$0.title = "appraisalHelpNeeded_fieldTitle".localized
			$0.value = helpNeeded
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.helpNeeded = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		hasNutritionistRow = SwitchRow("hasNutritionist") {
			$0.title = "appraisalHasNutritionist_fieldTitle".localized
			$0.value = hasNutritionist
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.hasNutritionist = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		commentsRow = TextAreaRow("comments") {
			$0.placeholder = "appraisalComments_placeholder".localized
			$0.value = comments
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.comments = value
					self.toggleConfirmationButton()
				}
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		form += [
			Section() <<< goalRow <<< sessionsByWeekRow,
			Section() <<< contraindicationRow <<< sportAntecedentsRow <<< helpNeededRow <<< hasNutritionistRow <<< commentsRow
		]
	}
}
