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
	fileprivate func setUIComponents() {
		warmUpRow = DecimalRow("warmUp") {
			$0.title = "newTestWarmUp_title".localized
			$0.placeholder = "newTestWarmUp_placeholder".localized
			$0.value = warmUp
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.warmUp = value
					self.toggleAddButton()
				}
			}
		}
		
		startSpeedRow = DecimalRow("startSpeed") {
			$0.title = "newTestStartSpeed_title".localized
			$0.placeholder = "newTestStartSpeed_placeholder".localized
			$0.value = startSpeed
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.startSpeed = value
					self.toggleAddButton()
				}
			}
		}
		
		increaseRow = DecimalRow("increase") {
			$0.title = "newTestIncrease_title".localized
			$0.placeholder = "newTestIncrease_placeholder".localized
			$0.value = increase
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.increase = value
					self.toggleAddButton()
				}
			}
		}
		
		frequencyRow = DecimalRow("frequency") {
			$0.title = "newTestWarmUp_title".localized
			$0.placeholder = "newTestWarmUp_placeholder".localized
			$0.value = frequency
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.frequency = value
					self.toggleAddButton()
				}
			}
		}
		
		kneeFlexibilityRow = DecimalRow("kneeFlexibility") {
			$0.title = "newTestWarmUp_title".localized
			$0.placeholder = "newTestWarmUp_placeholder".localized
			$0.value = kneeFlexibility
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.kneeFlexibility = value
					self.toggleAddButton()
				}
			}
		}
		
		shinFlexibilityRow = DecimalRow("shinFlexibility") {
			$0.title = "newTestWarmUp_title".localized
			$0.placeholder = "newTestWarmUp_placeholder".localized
			$0.value = shinFlexibility
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.shinFlexibility = value
					self.toggleAddButton()
				}
			}
		}
		
		hitFootFlexibilityRow = DecimalRow("hitFootFlexibility") {
			$0.title = "newTestWarmUp_title".localized
			$0.placeholder = "newTestWarmUp_placeholder".localized
			$0.value = hitFootFlexibility
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.hitFootFlexibility = value
					self.toggleAddButton()
				}
			}
		}
		
		closedFistGroundFlexibilityRow = DecimalRow("closedFistGroundFlexibility") {
			$0.title = "newTestWarmUp_title".localized
			$0.placeholder = "newTestWarmUp_placeholder".localized
			$0.value = closedFistGroundFlexibility
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.closedFistGroundFlexibility = value
					self.toggleAddButton()
				}
			}
		}
		
		handFlatGroundFlexibilityRow = DecimalRow("handFlatGroundFlexibility") {
			$0.title = "newTestWarmUp_title".localized
			$0.placeholder = "newTestWarmUp_placeholder".localized
			$0.value = handFlatGroundFlexibility
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.handFlatGroundFlexibility = value
					self.toggleAddButton()
				}
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		form += [
			Section() <<< warmUpRow <<< startSpeedRow <<< increaseRow <<< frequencyRow,
			Section() <<< kneeFlexibilityRow <<< shinFlexibilityRow <<< closedFistGroundFlexibilityRow <<< handFlatGroundFlexibilityRow
		]
	}
}
