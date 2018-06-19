//
//  AddMeasurements+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 18/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

extension AddMeasurementsController {
	fileprivate func setUIComponents() {
		weightRow = DecimalRow("weight") {
			$0.title = "addMeasurementsWeight_fieldTitle".localized
			$0.placeholder = "cm_placeholder".localized
			$0.value = weight
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.weight = value
					self.toggleUpdateButton()
				}
			}
		}
		
		heightRow = DecimalRow("height") {
			$0.title = "addMeasurementsHeight_fieldTitle".localized
			$0.placeholder = "cm_placeholder".localized
			$0.value = height
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.height = value
					self.toggleUpdateButton()
				}
			}
		}
		
		hipCircumferenceRow = DecimalRow("hipCircumference") {
			$0.title = "addMeasurementsHipCircumference_fieldTitle".localized
			$0.placeholder = "cm_placeholder".localized
			$0.value = hipCircumference
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.hipCircumference = value
					self.toggleUpdateButton()
				}
			}
		}
		
		waistCircumferenceRow = DecimalRow("waistCircumference") {
			$0.title = "addMeasurementsWaistCircumference_fieldTitle".localized
			$0.placeholder = "cm_placeholder".localized
			$0.value = waistCircumference
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.waistCircumference = value
					self.toggleUpdateButton()
				}
			}
		}
		
		thighCircumferenceRow = DecimalRow("thighCircumference") {
			$0.title = "addMeasurementsThighCircumference_fieldTitle".localized
			$0.placeholder = "cm_placeholder".localized
			$0.value = thighCircumference
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.thighCircumference = value
					self.toggleUpdateButton()
				}
			}
		}
		
		armCircumferenceRow = DecimalRow("armCircumference") {
			$0.title = "addMeasurementsArmCircumference_fieldTitle".localized
			$0.placeholder = "cm_placeholder".localized
			$0.value = armCircumference
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.armCircumference = value
					self.toggleUpdateButton()
				}
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		form += [
			Section() <<< weightRow <<< heightRow,
			Section() <<< hipCircumferenceRow <<< waistCircumferenceRow <<< thighCircumferenceRow <<< armCircumferenceRow
		]
	}
}
