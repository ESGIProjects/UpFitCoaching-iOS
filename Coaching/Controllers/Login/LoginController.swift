//
//  LoginController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import RealmSwift

class LoginController: UIViewController {
	
	// MARK: - UI
	
	lazy var scrollView = UI.scrollView()
	lazy var contentView = UI.contentView()
	lazy var titleLabel = UI.titleLabel()
	lazy var mailTextField = UI.mailTextField()
	lazy var passwordTextField = UI.passwordTextField()
	lazy var loginButton = UI.loginButton(self, action: #selector(signIn(_:)))
	lazy var signUpButton = UI.signUpButton(self, action: #selector(signUp(_:)))
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "login_title".localized
		edgesForExtendedLayout = []
		
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	// MARK: - Helpers
	
	private func setupLayout() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(mailTextField)
		contentView.addSubview(passwordTextField)
		contentView.addSubview(loginButton)
		contentView.addSubview(signUpButton)
		
		let constraints = UI.getConstraints(for: self)
		NSLayoutConstraint.activate(constraints)
	}
	
	// MARK: - Actions
	
	@objc func signIn(_ sender: UIButton) {
		
		// Check if the form is complete
		
		guard let mailValue = mailTextField.text, mailValue != "" else {
			present(UIAlertController.simpleAlert(title: "mail_missing_title".localized, message: nil), animated: true)
			return
		}
		
		guard let passwordValue = passwordTextField.text, passwordValue != "" else {
			present(UIAlertController.simpleAlert(title: "password_missing_title".localized, message: nil), animated: true)
			return
		}
		
		// Perform the network call
		
		Network.login(mail: mailValue, password: passwordValue) { [weak self] data, response, _ in
			
			guard let response = response as? HTTPURLResponse,
				let data = data else { return }
			
			// Print the HTTP status code
			print("Status code:", response.statusCode)
			
			// Creating the JSON decoder
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(dateFormatter)
			
			// If the login is a success
			if response.statusCode == 200 {
				// Decode user data
				guard let user = try? decoder.decode(User.self, from: data) else { return }
				print(user)
				
				// Save user info
				Database().createOrUpdate(model: user, with: UserObject.init)
				UserDefaults.standard.set(user.userID, forKey: "userID")
				
				// Present the correct controller for the user
				let tabBarController = user.type == 2 ? UITabBarController.coachController() : UITabBarController.clientController()
				
				DispatchQueue.main.async {
					self?.present(tabBarController, animated: true) {
						self?.mailTextField.text = ""
						self?.passwordTextField.text = ""
					}
				}
			} else {
				// Display the error sent by the server
				guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
				
				let alertController = UIAlertController.simpleAlert(title: "error".localized, message: errorMessage.message.localized)
				
				DispatchQueue.main.async {
					self?.present(alertController, animated: true)
				}
			}
		}
	}
	
	@objc func signUp(_ sender: UIButton) {
		navigationController?.pushViewController(SignUpController(), animated: true)
	}
}
