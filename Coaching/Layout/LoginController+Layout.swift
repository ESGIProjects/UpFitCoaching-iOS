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
	
	func createScrollView() -> UIScrollView {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.keyboardDismissMode = .interactive
		return scrollView
	}
	
	func createContentView() -> UIView {
		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		return contentView
	}
	
	func createTitleLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Coaching App"
		label.font = UIFont.preferredFont(forTextStyle: .title1)
		return label
	}
	
	func createMailTextField() -> UITextField {
		let textField = UITextField(frame: .zero)
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.borderStyle = .roundedRect
		textField.keyboardType = .emailAddress
		textField.returnKeyType = .next
		textField.placeholder = "mail_placeholder".localized
		return textField
	}
	
	func createPassworTextField() -> UITextField {
		let textField = UITextField(frame: .zero)
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.borderStyle = .roundedRect
		textField.isSecureTextEntry = true
		textField.returnKeyType = .done
		textField.placeholder = "password_placeholder".localized
		return textField
	}
	
	func createLoginButton() -> UIButton {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("login_button".localized, for: .normal)
		button.setTitleColor(.red, for: .normal)
		button.addTarget(self, action: #selector(signin(_:)), for: .touchUpInside)
		return button
	}
	
	// MARK: - Constraints
	
	func layoutConstraints() -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()
		
		if #available(iOS 11.0, *) {
			constraints += [
				scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
			]
		} else {
			constraints += [
				scrollView.topAnchor.constraint(equalTo: view.topAnchor),
				scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			]
		}
		
		constraints += [
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
			
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			mailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0),
			mailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			mailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 10.0),
			passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10.0),
			loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10.0),
			loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0)
		]
		
		return constraints
	}
}
