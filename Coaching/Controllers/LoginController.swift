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
		
		let conversationListController = ConversationListController()
		present(UINavigationController(rootViewController: conversationListController), animated: true)
		
//		Network.login(mail: mailValue, password: passwordValue) { (data, response, error) in
//			print(data ?? "No data")
//			print(response ?? "no response")
//			print(error ?? "no error")
//		}
	}
}
