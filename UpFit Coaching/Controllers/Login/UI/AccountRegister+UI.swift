//
//  AccountRegister+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension AccountRegisterController {
	class UI {
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
		
		class func nextButton() -> UIButton {
			let view = UIButton(type: .system)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.setTitle("Next", for: .normal)
			
			return view
		}
	}
	
	func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			mailTextField.topAnchor.constraint(equalTo: anchors.top),
			mailTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			mailTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 10.0),
			passwordTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			passwordTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10.0),
			confirmPasswordTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			confirmPasswordTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			nextButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 10.0),
			nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		]
	}
	
	func setUIComponents() {
		mailTextField = UI.mailTextField()
		passwordTextField = UI.passwordTextField()
		confirmPasswordTextField = UI.confirmPasswordTextField()
		
		nextButton = UI.nextButton()
		nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(mailTextField)
		view.addSubview(passwordTextField)
		view.addSubview(confirmPasswordTextField)
		view.addSubview(nextButton)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
