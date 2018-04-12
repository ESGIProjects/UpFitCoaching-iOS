//
//  SignUpController+UI.swift
//  Coaching
//
//  Created by Jason Pierna on 11/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

//swiftlint:disable type_name

import UIKit

extension SignUpController {
	class UI {
		class func scrollView() -> UIScrollView {
			let view = UIScrollView()
			view.translatesAutoresizingMaskIntoConstraints = false
			view.keyboardDismissMode = .interactive
			return view
		}
		
		class func contentView() -> UIView {
			let view = UIView()
			view.translatesAutoresizingMaskIntoConstraints = false
			return view
		}
		
		class func firstNameTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "firstName_placeholder".localized
			return textField
		}
		
		class func lastNameTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.keyboardType = .emailAddress
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "lastName_placeholder".localized
			return textField
		}
		
		class func mailTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.keyboardType = .emailAddress
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "mail_placeholder".localized
			return textField
		}
		
		class func passwordTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.isSecureTextEntry = true
			textField.returnKeyType = .done
			textField.placeholder = "password_placeholder".localized
			return textField
		}
		
		class func confirmPasswordTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.isSecureTextEntry = true
			textField.returnKeyType = .done
			textField.placeholder = "confirmPassword_placeholder".localized
			return textField
		}
		
		class func birthDatePicker() -> UIDatePicker {
			let picker = UIDatePicker(frame: .zero)
			picker.translatesAutoresizingMaskIntoConstraints = false
			picker.datePickerMode = .date
			picker.locale = Locale.current
			picker.maximumDate = picker.date
			return picker
		}
		
		class func signUpButton(_ target: Any?, action: Selector) -> UIButton {
			let button = UIButton()
			button.translatesAutoresizingMaskIntoConstraints = false
			button.setTitle("signUp_button".localized, for: .normal)
			button.setTitleColor(.red, for: .normal)
			button.addTarget(target, action: action, for: .touchUpInside)
			return button
		}
		
		//swiftlint:disable identifier_name
		class func getConstraints(for c: SignUpController) -> [NSLayoutConstraint] {
			var constraints = [NSLayoutConstraint]()
			
			if #available(iOS 11.0, *) {
				constraints += [
					c.scrollView.topAnchor.constraint(equalTo: c.view.safeAreaLayoutGuide.topAnchor),
					c.scrollView.bottomAnchor.constraint(equalTo: c.view.safeAreaLayoutGuide.bottomAnchor),
					c.scrollView.leadingAnchor.constraint(equalTo: c.view.safeAreaLayoutGuide.leadingAnchor),
					c.scrollView.trailingAnchor.constraint(equalTo: c.view.safeAreaLayoutGuide.trailingAnchor)
				]
			} else {
				constraints += [
					c.scrollView.topAnchor.constraint(equalTo: c.view.topAnchor),
					c.scrollView.bottomAnchor.constraint(equalTo: c.view.bottomAnchor),
					c.scrollView.leadingAnchor.constraint(equalTo: c.view.leadingAnchor),
					c.scrollView.trailingAnchor.constraint(equalTo: c.view.trailingAnchor)
				]
			}
			
			constraints += [
				c.contentView.topAnchor.constraint(equalTo: c.scrollView.topAnchor),
				c.contentView.bottomAnchor.constraint(equalTo: c.scrollView.bottomAnchor),
				c.contentView.leadingAnchor.constraint(equalTo: c.scrollView.leadingAnchor),
				c.contentView.trailingAnchor.constraint(equalTo: c.scrollView.trailingAnchor),
				c.contentView.widthAnchor.constraint(equalTo: c.view.widthAnchor),
				
				c.firstNameTextField.topAnchor.constraint(equalTo: c.contentView.topAnchor, constant: 30.0),
				c.firstNameTextField.leadingAnchor.constraint(equalTo: c.contentView.leadingAnchor, constant: 10.0),
				c.firstNameTextField.trailingAnchor.constraint(equalTo: c.contentView.trailingAnchor, constant: -10.0),
				
				c.lastNameTextField.topAnchor.constraint(equalTo: c.firstNameTextField.bottomAnchor, constant: 15.0),
				c.lastNameTextField.leadingAnchor.constraint(equalTo: c.contentView.leadingAnchor, constant: 10.0),
				c.lastNameTextField.trailingAnchor.constraint(equalTo: c.contentView.trailingAnchor, constant: -10.0),
				
				c.mailTextField.topAnchor.constraint(equalTo: c.lastNameTextField.bottomAnchor, constant: 15.0),
				c.mailTextField.leadingAnchor.constraint(equalTo: c.contentView.leadingAnchor, constant: 10.0),
				c.mailTextField.trailingAnchor.constraint(equalTo: c.contentView.trailingAnchor, constant: -10.0),
				
				c.passwordTextField.topAnchor.constraint(equalTo: c.mailTextField.bottomAnchor, constant: 15.0),
				c.passwordTextField.leadingAnchor.constraint(equalTo: c.contentView.leadingAnchor, constant: 10.0),
				c.passwordTextField.trailingAnchor.constraint(equalTo: c.contentView.trailingAnchor, constant: -10.0),
				
				c.confirmPasswordTextField.topAnchor.constraint(equalTo: c.passwordTextField.bottomAnchor, constant: 15.0),
				c.confirmPasswordTextField.leadingAnchor.constraint(equalTo: c.contentView.leadingAnchor, constant: 10.0),
				c.confirmPasswordTextField.trailingAnchor.constraint(equalTo: c.contentView.trailingAnchor, constant: -10.0),
				
				c.birthDatePicker.topAnchor.constraint(equalTo: c.confirmPasswordTextField.bottomAnchor, constant: 15.0),
				c.birthDatePicker.leadingAnchor.constraint(equalTo: c.contentView.leadingAnchor, constant: 10.0),
				c.birthDatePicker.trailingAnchor.constraint(equalTo: c.contentView.trailingAnchor, constant: -10.0),
				
				c.signUpButton.topAnchor.constraint(equalTo: c.birthDatePicker.bottomAnchor, constant: 15.0),
				c.signUpButton.bottomAnchor.constraint(equalTo: c.contentView.bottomAnchor, constant: -10.0),
				c.signUpButton.leadingAnchor.constraint(equalTo: c.contentView.leadingAnchor, constant: 10.0),
				c.signUpButton.trailingAnchor.constraint(equalTo: c.contentView.trailingAnchor, constant: -10.0)
			]
			
			return constraints
		}
	}
}
