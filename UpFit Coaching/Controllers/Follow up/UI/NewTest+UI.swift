//
//  NewTest+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 18/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

extension NewTestController {
	fileprivate func flexibilitySection() {
		kneeFlexibilityRow = AlertRow<Flexibility>("kneeFlexibility") {
			$0.title = "newTestKneeFlexibility_fieldTitle".localized
			$0.options = [.weak, .average, .good, .veryGood]
			$0.value = kneeFlexibility
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				return "flexibilityValue_\(value.rawValue)".localized
			}
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.kneeFlexibility = value
					self.toggleAddButton()
				}
			}
		}
		
		shinFlexibilityRow = AlertRow<Flexibility>("shinFlexibility") {
			$0.title = "newTestShinFlexibility_fieldTitle".localized
			$0.options = [.weak, .average, .good, .veryGood]
			$0.value = shinFlexibility
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				return "flexibilityValue_\(value.rawValue)".localized
			}
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.shinFlexibility = value
					self.toggleAddButton()
				}
			}
		}
		
		hitFootFlexibilityRow = AlertRow<Flexibility>("hitFootFlexibility") {
			$0.title = "newTestHitFootFlexibility_fieldTitle".localized
			$0.options = [.weak, .average, .good, .veryGood]
			$0.value = hitFootFlexibility
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				return "flexibilityValue_\(value.rawValue)".localized
			}
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.hitFootFlexibility = value
					self.toggleAddButton()
				}
			}
		}
		
		closedFistGroundFlexibilityRow = AlertRow<Flexibility>("closedFistGroundFlexibility") {
			$0.title = "newTestClosedFistGroundFlexibility_fieldTitle".localized
			$0.value = closedFistGroundFlexibility
			$0.options = [.weak, .average, .good, .veryGood]
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				return "flexibilityValue_\(value.rawValue)".localized
			}
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.closedFistGroundFlexibility = value
					self.toggleAddButton()
				}
			}
		}
		
		handFlatGroundFlexibilityRow = AlertRow<Flexibility>("handFlatGroundFlexibility") {
			$0.title = "newTestHandFlatGroundFlexibility_fieldTitle".localized
			$0.value = handFlatGroundFlexibility
			$0.options = [.weak, .average, .good, .veryGood]
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				return "flexibilityValue_\(value.rawValue)".localized
			}
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.handFlatGroundFlexibility = value
					self.toggleAddButton()
				}
			}
		}
	}
	
	fileprivate func VMASection() {
		warmUpRow = DecimalRow("warmUp") {
			$0.title = "newTestWarmUp_fieldTitle".localized
			$0.placeholder = "km/h_placeholder".localized
			$0.value = warmUp
			$0.onChange { [unowned self] row in
				self.warmUp = row.value
				self.toggleAddButton()
				
			}
		}
		
		startSpeedRow = DecimalRow("startSpeed") {
			$0.title = "newTestStartSpeed_fieldTitle".localized
			$0.placeholder = "km/h_placeholder".localized
			$0.value = startSpeed
			$0.onChange { [unowned self] row in
				self.startSpeed = row.value
				self.toggleAddButton()
				
			}
		}
		
		increaseRow = DecimalRow("increase") {
			$0.title = "newTestIncrease_fieldTitle".localized
			$0.placeholder = "km/h_placeholder".localized
			$0.value = increase
			$0.onChange { [unowned self] row in
				self.increase = row.value
				self.toggleAddButton()
				
			}
		}
		
		frequencyRow = DecimalRow("frequency") {
			$0.title = "newTestFrequency_fieldTitle".localized
			$0.placeholder = "seconds_placeholder".localized
			$0.value = frequency
			$0.onChange { [unowned self] row in
				self.frequency = row.value
				self.toggleAddButton()
			}
		}
	}
	
	fileprivate func setUIComponents() {
		VMASection()
		flexibilitySection()
	}
	
	func setupLayout() {
		setUIComponents()
		
		form += [
			Section("newTestVVO2max_sectionTitle".localized) <<< warmUpRow <<< startSpeedRow <<< increaseRow <<< frequencyRow,
			Section("newTestFlexibility_sectionTitle".localized) <<< kneeFlexibilityRow <<< shinFlexibilityRow <<< hitFootFlexibilityRow <<< closedFistGroundFlexibilityRow <<< handFlatGroundFlexibilityRow
		]
	}
}
