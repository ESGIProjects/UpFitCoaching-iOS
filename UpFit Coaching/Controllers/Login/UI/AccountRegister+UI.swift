//
//  AccountRegister+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

extension AccountRegisterController {
	fileprivate func setUIComponents() {
		mailRow = EmailRow("mail") {
			$0.title = "mail_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = registerController?.registerBox.mail
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.mail = value
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
		
		passwordRow = PasswordRow("password") {
			$0.title = "password_fieldTitle".localized
			$0.placeholder = "requiredField".localized
			$0.value = registerController?.registerBox.password
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.password = value
				}
			}
			
			$0.add(rule: RuleRequired(msg: "password_missingTitle".localized))
			$0.validationOptions = .validatesOnChange
			$0.cellUpdate { cell, row in
				if !row.isValid {
					cell.titleLabel?.textColor = .red
				}
			}
		}
		
		confirmPasswordRow = PasswordRow("confirmPassword") {
			$0.title = "confirmPassword_fieldTitle".localized
			$0.placeholder = "requiredField".localized
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
		
		nextRow = ButtonRow {
			$0.title = "nextButton".localized
			$0.cellUpdate { cell, _ in
				cell.textLabel?.textColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
			}
			$0.onCellSelection { [unowned self] _, _ in
				self.next()
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		form += [
			Section() <<< mailRow <<< passwordRow <<< confirmPasswordRow,
			Section() <<< nextRow
		]
	}
}
