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
			$0.title = "appraisalGoal_title".localized
			$0.placeholder = "appraisalGoal_placeholder".localized
			$0.value = goal
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.goal = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		totalSessionsByWeekRow = StepperRow("totalSessionsByWeek") {
			$0.title = "appraisalSessionsByWeek_title".localized
			$0.value = Double(totalSessionsByWeek)
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.totalSessionsByWeek = Int(value)
					self.toggleConfirmationButton()
				}
			}
		}
		
		contraindicationRow = TextRow("contraindication") {
			$0.title = "appraisalContraindication_title".localized
			$0.placeholder = "appraisalContraindication_placeholder".localized
			$0.value = contraindication
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.contraindication = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		sportsAntecedentsRow = TextRow("sportsAntecedents") {
			$0.title = "appraisalSportsAntecedents_title".localized
			$0.placeholder = "appraisalSportsAntecedents_placeholder".localized
			$0.value = sportsAntecedents
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.sportsAntecedents = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		helpNeededRow = SwitchRow("helpNeeded") {
			$0.title = "appraisalHelpNeeded_title".localized
			$0.value = helpNeeded
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.helpNeeded = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		hasNutritionistRow = SwitchRow("hasNutritionist") {
			$0.title = "appraisalHasNutritionist_title".localized
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
			Section() <<< goalRow <<< totalSessionsByWeekRow,
			Section() <<< contraindicationRow <<< sportsAntecedentsRow <<< helpNeededRow <<< hasNutritionistRow <<< commentsRow
		]
	}
}
