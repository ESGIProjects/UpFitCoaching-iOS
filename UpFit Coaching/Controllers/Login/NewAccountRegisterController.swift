//
//  AccountRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 21/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class AccountRegisterController: FormViewController {
	
	weak var registerController: RegisterController?
	
	convenience init(registerController: RegisterController) {
		self.init()
		self.registerController = registerController
	}
	
	func setupLayout() {
		
		let mailSection = Section()
		
		mailSection <<< EmailRow("mail") {
			$0.title = "Adresse e-mail"
			$0.placeholder = "mail_placeholder".localized
			$0.value = registerController?.registerBox.mail
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.mail = value
				}
			}
			$0.add(rule: RuleRequired(msg: "mail_missing_title".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		mailSection	<<< PasswordRow("password") {
			$0.title = "Mot de passe"
			$0.placeholder = "password_placeholder".localized
			$0.value = registerController?.registerBox.password
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.password = value
				}
			}
			$0.add(rule: RuleRequired(msg: "password_missing_title".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		mailSection <<< PasswordRow("confirmPassword") {
			$0.title = "Confirmation"
			$0.placeholder = "confirmPassword_placeholder".localized
			$0.hidden = Condition.function(["password"], { form -> Bool in
				guard let passwordRow = form.rowBy(tag: "password") as? PasswordRow,
					let passwordValue = passwordRow.value else { return true }
				return passwordValue.count == 0
			})
			$0.add(rule: RuleEqualsToRow(form: form, tag: "password", msg: "confirmPassword_error_title".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		form +++ mailSection
		
		let buttonSection = Section()
		
		buttonSection <<< ButtonRow {
			$0.title = "Next"
			$0.onCellSelection { [unowned self] _, _ in
				self.next()
			}
		}
		
		form +++ buttonSection
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLayout()
	}
	
	@objc func next() {
		let validationErrors = form.validate()
		
		if validationErrors.isEmpty {
			registerController?.goToDetails(.forward)
		} else {
			guard let error = validationErrors.first else { return }
			presentAlert(title: error.msg, message: nil)
		}
	}
}
