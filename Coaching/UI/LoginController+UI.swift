//
//  LoginController+UI.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

//swiftlint:disable type_name

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
		
		class func segmentedControl() -> UISegmentedControl {
			let view = UISegmentedControl(items: ["login_is_coach".localized, "login_is_client".localized])
			view.translatesAutoresizingMaskIntoConstraints = false
			view.selectedSegmentIndex = 0
			return view
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
		
		class func loginButton(_ target: Any?, action: Selector) -> UIButton {
			let button = UIButton()
			button.translatesAutoresizingMaskIntoConstraints = false
			button.setTitle("login_button".localized, for: .normal)
			button.setTitleColor(.red, for: .normal)
			button.addTarget(target, action: action, for: .touchUpInside)
			return button
		}
		
		class func getConstraints(for controller: LoginController) -> [NSLayoutConstraint] {
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
				
				controller.titleLabel.topAnchor.constraint(equalTo: controller.contentView.topAnchor, constant: 30.0),
				controller.titleLabel.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.titleLabel.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.segmentedControl.topAnchor.constraint(equalTo: controller.titleLabel.bottomAnchor, constant: 30.0),
				controller.segmentedControl.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.segmentedControl.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.mailTextField.topAnchor.constraint(equalTo: controller.segmentedControl.bottomAnchor, constant: 15.0),
				controller.mailTextField.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.mailTextField.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.passwordTextField.topAnchor.constraint(equalTo: controller.mailTextField.bottomAnchor, constant: 10.0),
				controller.passwordTextField.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.passwordTextField.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0),
				
				controller.loginButton.topAnchor.constraint(equalTo: controller.passwordTextField.bottomAnchor, constant: 10.0),
				controller.loginButton.bottomAnchor.constraint(equalTo: controller.contentView.bottomAnchor, constant: 10.0),
				controller.loginButton.leadingAnchor.constraint(equalTo: controller.contentView.leadingAnchor, constant: 10.0),
				controller.loginButton.trailingAnchor.constraint(equalTo: controller.contentView.trailingAnchor, constant: -10.0)
			]
			
			return constraints
		}
	}
}
