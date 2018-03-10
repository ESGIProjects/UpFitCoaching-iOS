//
//  LoginController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
	
	lazy var titleLabel = createTitleLabel()
	lazy var mailTextField = createMailTextField()
	lazy var passwordTextField = createPassworTextField()
	lazy var loginButton = createLoginButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Login"
		
		setupLayout()
	}
	
	func setupLayout() {
		// Text fields
		view.addSubview(titleLabel)
		view.addSubview(mailTextField)
		view.addSubview(passwordTextField)
		view.addSubview(loginButton)
		
		NSLayoutConstraint.activate(layoutConstraints())
	}
	
	@objc func signin(_ sender: UIButton) {
		guard let mailValue = mailTextField.text else {
			let alert = UIAlertController(title: "Mail missing", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			present(alert, animated: true)
			return
		}
		
		guard let passwordValue = passwordTextField.text else {
			let alert = UIAlertController(title: "Password missing", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			present(alert, animated: true)
			return
		}
		
		Network.login(mail: mailValue, password: passwordValue) { (data, response, error) in
			print(data ?? "No data")
			print(response ?? "no response")
			print(error ?? "no error")
		}
	}
}
