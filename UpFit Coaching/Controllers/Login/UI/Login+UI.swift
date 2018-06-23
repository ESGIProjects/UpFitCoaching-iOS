//
//  Login+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension LoginController {		
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			scrollView.topAnchor.constraint(equalTo: anchors.top),
			scrollView.bottomAnchor.constraint(equalTo: anchors.bottom),
			scrollView.leadingAnchor.constraint(equalTo: anchors.leading),
			scrollView.trailingAnchor.constraint(equalTo: anchors.trailing),
			
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
			
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30.0),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			mailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0),
			mailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			mailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 10.0),
			passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20.0),
			loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5.0),
			signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10.0),
			signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0)
		]
	}
	
	fileprivate func setUIComponents() {
		scrollView = UI.genericScrollView
		contentView = UI.genericView
		
		titleLabel = UI.titleLabel
		titleLabel.text = "app_name".localized
		titleLabel.textAlignment = .center
		
		mailTextField = UI.roundedTextField
		mailTextField.keyboardType = .emailAddress
		mailTextField.returnKeyType = .next
		mailTextField.placeholder = "mail_placeholder".localized
		
		passwordTextField = UI.roundedTextField
		passwordTextField.isSecureTextEntry = true
		passwordTextField.returnKeyType = .done
		passwordTextField.placeholder = "password_placeholder".localized
		
		loginButton = UI.genericButton
		loginButton.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
		loginButton.titleText = "loginButton".localized
		loginButton.titleColor = .main

		signUpButton = UI.genericButton
		signUpButton.addTarget(self, action: #selector(signUp(_:)), for: .touchUpInside)
		signUpButton.titleFont = .systemFont(ofSize: 15)
		signUpButton.titleText = "signUpButton_long".localized
		signUpButton.titleColor = .main
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(mailTextField)
		contentView.addSubview(passwordTextField)
		contentView.addSubview(loginButton)
		contentView.addSubview(signUpButton)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
