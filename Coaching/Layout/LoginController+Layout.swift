//
//  LoginController+Layout.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension LoginController {
	
	// MARK: - Creating elements
	
	func createTitleLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Coaching App"
		label.font = UIFont.preferredFont(forTextStyle: .title1)
		return label
	}
	
	func createMailTextField() -> UITextField {
		let mailTextField = UITextField(frame: .zero)
		mailTextField.translatesAutoresizingMaskIntoConstraints = false
		mailTextField.borderStyle = .roundedRect
		mailTextField.keyboardType = .emailAddress
		mailTextField.returnKeyType = .next
		mailTextField.placeholder = "Mail"
		return mailTextField
	}
	
	func createPassworTextField() -> UITextField {
		let passwordTextField = UITextField(frame: .zero)
		passwordTextField.translatesAutoresizingMaskIntoConstraints = false
		passwordTextField.borderStyle = .roundedRect
		passwordTextField.isSecureTextEntry = true
		passwordTextField.returnKeyType = .done
		passwordTextField.placeholder = "Password"
		return passwordTextField
	}
	
	func createLoginButton() -> UIButton {
		let loginButton = UIButton()
		loginButton.translatesAutoresizingMaskIntoConstraints = false
		loginButton.setTitle("Sign In", for: .normal)
		loginButton.setTitleColor(.red, for: .normal)
		loginButton.addTarget(self, action: #selector(signin(_:)), for: .touchUpInside)
		return loginButton
	}
	
	// MARK: - Constraints
	
	func layoutConstraints() -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()
		
		if #available(iOS 11.0, *) {
			constraints += [
				titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
				titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
				titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
				
				mailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
				mailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
				
				passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
				passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
				
				loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
				loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0)
			]
		} else {
			constraints += [
				titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
				titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
				titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
				
				mailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
				mailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
				
				passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
				passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
				
				loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
				loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0)
			]
		}
		
		constraints += [
			mailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0),
			
			passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 10.0),
			
			loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10.0)
		]
		
		return constraints
	}
}
