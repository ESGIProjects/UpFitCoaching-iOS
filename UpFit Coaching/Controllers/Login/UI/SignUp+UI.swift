//
//  SignUp+UI.swift
//  Coaching
//
//  Created by Jason Pierna on 11/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

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
		
		class func getConstraints(for controller: SignUpController) -> [NSLayoutConstraint] {
			var constraints = [NSLayoutConstraint]()
			
			if #available(iOS 11.0, *) {
				constraints += [
					controller.scrollView.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
					controller.scrollView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor),
					controller.scrollView.leadingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leadingAnchor),
					controller.scrollView.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor)
				]
			} else {
				constraints += [
					controller.scrollView.topAnchor.constraint(equalTo: controller.view.topAnchor),
					controller.scrollView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
					controller.scrollView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
					controller.scrollView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor)
				]
			}
			
			constraints += [
				controller.contentView.topAnchor.constraint(equalTo: controller.scrollView.topAnchor),
				controller.contentView.bottomAnchor.constraint(equalTo: controller.scrollView.bottomAnchor),
				controller.contentView.leadingAnchor.constraint(equalTo: controller.scrollView.leadingAnchor),
				controller.contentView.trailingAnchor.constraint(equalTo: controller.scrollView.trailingAnchor),
				controller.contentView.widthAnchor.constraint(equalTo: controller.view.widthAnchor),
				
				controller.firstNameTextField.topAnchor.constraint(equalTo: controller.contentView.topAnchor, constant: 30.0),
				controller.firstNameTextField.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.firstNameTextField.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.lastNameTextField.topAnchor.constraint(equalTo: controller.firstNameTextField.bottomAnchor, constant: 15.0),
				controller.lastNameTextField.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.lastNameTextField.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.mailTextField.topAnchor.constraint(equalTo: controller.lastNameTextField.bottomAnchor, constant: 15.0),
				controller.mailTextField.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.mailTextField.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.passwordTextField.topAnchor.constraint(equalTo: controller.mailTextField.bottomAnchor, constant: 15.0),
				controller.passwordTextField.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.passwordTextField.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.confirmPasswordTextField.topAnchor.constraint(equalTo: controller.passwordTextField.bottomAnchor, constant: 15.0),
				controller.confirmPasswordTextField.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.confirmPasswordTextField.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.birthDatePicker.topAnchor.constraint(equalTo: controller.confirmPasswordTextField.bottomAnchor, constant: 15.0),
				controller.birthDatePicker.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.birthDatePicker.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.signUpButton.topAnchor.constraint(equalTo: controller.birthDatePicker.bottomAnchor, constant: 15.0),
				controller.signUpButton.bottomAnchor.constraint(equalTo: controller.contentView.bottomAnchor, constant: -10.0),
				controller.signUpButton.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.signUpButton.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0)
			]
			
			return constraints
		}
	}
}
