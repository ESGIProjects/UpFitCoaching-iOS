//
//  EditProfileController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka
import PKHUD

class EditProfileController: FormViewController {
	
	var mailRow: EmailRow!
	var passwordRow: PasswordRow!
	var confirmPasswordRow: PasswordRow!
	var firstNameRow: NameRow!
	var lastNameRow: NameRow!
	var cityRow: TextRow!
	var phoneNumberRow: PhoneRow!
	var addressRow: TextRow?
	
	let currentUser = Database().getCurrentUser()
	
	var mail: String!
	var password: String!
	var firstName: String!
	var lastName: String!
	var city: String!
	var phoneNumber: String!
	var address: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "editProfileController_title".localized
		view.backgroundColor = .white
		
		// Default values
		mail = currentUser?.mail
		password = ""
		firstName = currentUser?.firstName
		lastName = currentUser?.lastName
		city = currentUser?.city
		phoneNumber = currentUser?.phoneNumber
		address = currentUser?.address
		
		setupLayout()
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editProfile))
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	@objc func editProfile() {
		guard let currentUser = currentUser else { return }
		
		let validationErrors = form.validate()
		
		if validationErrors.isEmpty {
			
			DispatchQueue.main.async {
				HUD.show(.progress)
				HUD.hide(afterDelay: 2.0)
			}
			
			// Network…
		} else {
			guard let error = validationErrors.first else { return }
			presentAlert(title: error.msg, message: nil)
		}
	}
}

extension EditProfileController {
	fileprivate func setPersonalSection() {
		mailRow = EmailRow("mail") {
			$0.title = "mail_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = mail
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.mail = value
				}
			}
			
			$0.add(rule: RuleRequired(msg: "mail_missingTitle".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		firstNameRow = NameRow("firstName") {
			$0.title = "firstName_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = firstName
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.firstName = value
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
			$0.value = lastName
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.lastName = value
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
	}
	
	fileprivate func setPasswordSection() {
		passwordRow = PasswordRow("password") {
			$0.title = "password_fieldTitle".localized
			$0.placeholder = "optionalField".localized
			$0.value = password
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.password = value
				}
			}
		}
		
		confirmPasswordRow = PasswordRow("confirmPassword") {
			$0.title = "confirmPassword_fieldTitle".localized
			$0.hidden = Condition.function(["password"]) { [unowned self] _ -> Bool in
				guard let password = self.passwordRow.value else { return true }
				return password.count == 0
			}
			
			$0.add(rule: RuleEqualsToRow(form: form, tag: "password", msg: "confirmPassword_errorTitle".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
	}
	
	fileprivate func setMiscSection() {
		cityRow = TextRow("city") {
			$0.title = "city_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = city
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.city = value
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
			$0.value = phoneNumber
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.phoneNumber = value
				}
			}
			
			$0.add(rule: RuleRequired(msg: "phoneNumber_missingTitle".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		if currentUser?.type == 2 {
			addressRow = TextRow("address") {
				$0.title = "address_fieldTitle".localized
				$0.placeholder = "requiredField".localized
				$0.value = address
				$0.onChange { [unowned self] row in
					self.address = row.value
				}
				
				$0.add(rule: RuleRequired(msg: "address_missingTitle".localized))
				$0.validationOptions = .validatesOnChange
				$0.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
				}
			}
		}
	}
	
	fileprivate func setUIComponents() {
		setPersonalSection()
		setPasswordSection()
		setMiscSection()
	}
	
	func setupLayout() {
		setUIComponents()
		
		let section = Section("miscellaneous_sectionTitle".localized)
		section <<< cityRow <<< phoneNumberRow
		
		if let addressRow = addressRow {
			section <<< addressRow
		}
		
		form += [
			Section("personalInfo_sectionTitle".localized) <<< mailRow <<< firstNameRow <<< lastNameRow,
			Section("password_fieldTitle".localized) <<< passwordRow <<< confirmPasswordRow,
			section
		]
	}
}
