//
//  Login+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension LoginController {	
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
		
		class func titleLabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.text = "app_name".localized
			label.font = UIFont.preferredFont(forTextStyle: .title1)
			label.textAlignment = .center
			
			return label
		}
		
		class func mailTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			
			textField.borderStyle = .roundedRect
			textField.keyboardType = .emailAddress
			textField.returnKeyType = .next
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
		
		class func loginButton() -> UIButton {
			let button = UIButton()
			button.translatesAutoresizingMaskIntoConstraints = false
			
			button.setTitle("login_button".localized, for: .normal)
			button.setTitleColor(.main, for: .normal)
			
			return button
		}
		
		class func signUpButton() -> UIButton {
			let button = UIButton()
			button.translatesAutoresizingMaskIntoConstraints = false
			
			let attributedString = NSAttributedString(string: "signUp_long_button".localized, attributes: [
				.font: UIFont.systemFont(ofSize: 15),
				.foregroundColor: UIColor.main
				])
			button.setAttributedTitle(attributedString, for: .normal)
			
			return button
		}
	}
	
	func getConstraints() -> [NSLayoutConstraint] {
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
	
	func setUIComponents() {
		scrollView = UI.scrollView()
		contentView = UI.contentView()
		titleLabel = UI.titleLabel()
		mailTextField = UI.mailTextField()
		passwordTextField = UI.passwordTextField()
		
		loginButton = UI.loginButton()
		loginButton.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)

		signUpButton = UI.signUpButton()
		signUpButton.addTarget(self, action: #selector(signUp(_:)), for: .touchUpInside)
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
