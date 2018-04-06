//
//  LoginController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
	
	lazy var scrollView = createScrollView()
	lazy var contentView = createContentView()
	lazy var titleLabel = createTitleLabel()
	lazy var mailTextField = createMailTextField()
	lazy var passwordTextField = createPassworTextField()
	lazy var loginButton = createLoginButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "login_title".localized
		edgesForExtendedLayout = []
		setupLayout()
		
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .never
		}
	}
	
	func setupLayout() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(mailTextField)
		contentView.addSubview(passwordTextField)
		contentView.addSubview(loginButton)
		
		NSLayoutConstraint.activate(layoutConstraints())
	}
	
	@objc func signin(_ sender: UIButton) {
		guard let mailValue = mailTextField.text, mailValue != "" else {
			let alert = UIAlertController(title: "mail_missing_title".localized, message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK_button".localized, style: .default))
			present(alert, animated: true)
			return
		}
		
		guard let passwordValue = passwordTextField.text, passwordValue != "" else {
			let alert = UIAlertController(title: "password_missing_title".localized, message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK_button".localized, style: .default))
			present(alert, animated: true)
			return
		}
		
//		let tabBarController = UITabBarController()
//
//		let conversationListController = ConversationListController()
//		tabBarController.setViewControllers([UINavigationController(rootViewController: conversationListController)], animated: true)
//
//		present(tabBarController, animated: true)
		
		Network.login(mail: mailValue, password: passwordValue) { (data, response, error) in
			
			guard let response = response as? HTTPURLResponse else { return }
			print("Status code:", response.statusCode)
			guard let data = data else { return }
			let decoder = JSONDecoder()
			
			if response.statusCode == 200 {
				do {
					let user = try decoder.decode(User.self, from: data)
					print(user)
				} catch {
					print(error.localizedDescription)
				}
			} else {
				do {
					let errorMessage = try decoder.decode(ErrorMessage.self, from: data)
					print(errorMessage.message)
				} catch {
					print(error.localizedDescription)
				}
			}
			
			
			
		}
	}
}

struct User: Codable {
	var id: Int
	var type: Int
	var mail: String
	var firstName: String
	var lastName: String
	var birthDate: String
	var city: String
	var phoneNumber: String
}

struct ErrorMessage: Codable {
	var message: String
}
