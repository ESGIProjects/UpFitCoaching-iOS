//
//  NewDetailsRegister+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka

extension DetailsRegisterController {
	
	fileprivate func setNameSectionRows() {
		firstNameRow = NameRow("firstName") {
			$0.title = "firstName_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = registerController?.registerBox.firstName
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.firstName = value
				}
			}
			
			$0.add(rule: RuleRequired(msg: "firstName_missingTitle".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		lastNameRow = NameRow("lastName") {
			$0.title = "lastName_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = registerController?.registerBox.lastName
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.lastName = value
				}
			}
			
			$0.add(rule: RuleRequired(msg: "lastName_missingTitle".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		sexRow = SegmentedRow<Int>("sex") {
			$0.options = [1, 0]
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				return "sex_\(value)".localized
			}
			$0.value = registerController?.registerBox.sex
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.sex = value
				}
			}
			
			$0.add(rule: RuleRequired(msg: "sex_missingTitle".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
	}
	
	fileprivate func setDetailsSectionRows() {
		cityRow = TextRow("city") {
			$0.title = "city_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = registerController?.registerBox.city
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.city = value
				}
			}
			
			$0.add(rule: RuleRequired(msg: "city_missingTitle".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		phoneNumberRow = PhoneRow("phoneNumber") {
			$0.title = "phoneNumber_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = registerController?.registerBox.phoneNumber
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.phoneNumber = value
				}
			}
			
			$0.add(rule: RuleRequired(msg: "phoneNumber_missingTitle".localized))
			$0.add(rule: RuleExactLength(exactLength: 10, msg: "phoneNumber_formatError".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		registerRow = ButtonRow {
			$0.title = "signUpButton_short".localized
			$0.cellUpdate { cell, _ in
				cell.textLabel?.textColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
			}
			$0.onCellSelection { [unowned self] _, _ in
				self.register()
			}
		}
	}
	
	fileprivate func setTypedRows() {
		if type == 2 {
			addressRow = TextRow("address") {
				$0.title = "address_fieldTitle".localized
				$0.placeholder = "requiredField".localized
				$0.value = registerController?.registerBox.address
				$0.onChange { [unowned self] row in
					self.registerController?.registerBox.address = row.value
				}
				
				$0.add(rule: RuleRequired(msg: "address_missingTitle".localized))
				$0.validationOptions = .validatesOnChange
				$0.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
				}
			}
		} else {
			birthDateRow = DateInlineRow("birthDate") {
				$0.title = "birthDate_fieldTitle".localized
				$0.value = registerController?.registerBox.birthDate
				
				let now = Date()
				let day = Calendar.current.component(.day, from: now)
				let month = Calendar.current.component(.month, from: now)
				let year = Calendar.current.component(.year, from: now)
				
				let minimumDateComponents = DateComponents(year: year - 100, month: month, day: day)
				let maximumDateComponents = DateComponents(year: year - 18, month: month, day: day)
				
				$0.minimumDate = Calendar.current.date(from: minimumDateComponents)
				$0.maximumDate = Calendar.current.date(from: maximumDateComponents)
				
				$0.onChange { [unowned self] row in
					if let value = row.value {
						self.registerController?.registerBox.birthDate = value
					}
				}
				
				$0.add(rule: RuleRequired(msg: "birthDate_missingTitle".localized))
				$0.validationOptions = .validatesOnChange
				$0.cellUpdate { cell, row in
					if !row.isValid {
						cell.textLabel?.textColor = .red
					}
				}
			}
		}
	}
	
	fileprivate func setUIComponents() {
		setNameSectionRows()
		setDetailsSectionRows()
		setTypedRows()
	}
	
	func setupLayout() {
		setUIComponents()
		
		var section = Section()
		section += [cityRow, phoneNumberRow]
		section.hidden = Condition.function(["firstName", "lastName"]) { [unowned self] _ in
			guard let firstNameValue = self.firstNameRow.value,
				let lastNameValue = self.lastNameRow.value else { return true }
			
			return firstNameValue == "" || lastNameValue == ""
		}
		
		if type == 2 {
			guard let addressRow = addressRow else { return }
			section <<< addressRow
		} else {
			guard let birthDateRow = birthDateRow else { return }
			section <<< birthDateRow
		}
		
		form += [
			Section() <<< firstNameRow <<< lastNameRow <<< sexRow,
			section,
			Section() <<< registerRow
		]
	}
}
