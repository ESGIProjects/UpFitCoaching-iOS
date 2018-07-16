//
//  Login+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

extension LoginController {		
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			
			scrollView.topAnchor.constraint(equalTo: anchors.top),
			scrollView.bottomAnchor.constraint(equalTo: anchors.bottom),
			scrollView.leadingAnchor.constraint(equalTo: anchors.leading),
			scrollView.trailingAnchor.constraint(equalTo: anchors.trailing),
			
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
			
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40.0),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			mailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.0),
			mailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			mailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			mailTextField.heightAnchor.constraint(equalToConstant: 44.0),
			
			passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 20.0),
			passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			passwordTextField.heightAnchor.constraint(equalToConstant: 44.0),
			
			loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30.0),
			loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			
			signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20.0),
			signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10.0),
			signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
			signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0)
		]
	}
	
	fileprivate func setUIComponents() {
		backgroundImage = UIImageView(image: #imageLiteral(resourceName: "loginBackground"))
		backgroundImage.translatesAutoresizingMaskIntoConstraints = false
		backgroundImage.contentMode = .scaleAspectFill
		
		scrollView = UI.genericScrollView
		contentView = UI.genericView
		
		titleLabel = UI.genericLabel
		titleLabel.font = .boldSystemFont(ofSize: 40)
		titleLabel.text = "app_name".localized
		titleLabel.textColor = .white
		titleLabel.textAlignment = .center
		
		mailTextField = UI.roundedTextField
		mailTextField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
		mailTextField.textColor = UIColor(red: 17.0/255.0, green: 142.0/255.0, blue: 135.0/255.0, alpha: 1.0)
		mailTextField.keyboardType = .emailAddress
		mailTextField.returnKeyType = .next
		mailTextField.placeholder = "mail_placeholder".localized
		
		passwordTextField = UI.roundedTextField
		passwordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
		passwordTextField.textColor = UIColor(red: 17.0/255.0, green: 142.0/255.0, blue: 135.0/255.0, alpha: 1.0)
		passwordTextField.isSecureTextEntry = true
		passwordTextField.returnKeyType = .done
		passwordTextField.placeholder = "password_placeholder".localized
		
		loginButton = UI.roundButton
		loginButton.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
		loginButton.titleText = "loginButton".localized

		signUpButton = UI.roundButton
		signUpButton.addTarget(self, action: #selector(signUp(_:)), for: .touchUpInside)
		signUpButton.titleText = "signUpButton_long".localized
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(backgroundImage)
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
