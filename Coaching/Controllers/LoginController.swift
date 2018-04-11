//
//  LoginController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
	
	lazy var scrollView = UI.scrollView()
	lazy var contentView = UI.contentView()
	lazy var titleLabel = UI.titleLabel()
	lazy var segmentedControl = UI.segmentedControl()
	lazy var mailTextField = UI.mailTextField()
	lazy var passwordTextField = UI.passwordTextField()
	lazy var loginButton = UI.loginButton(self, action: #selector(signIn(_:)))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "login_title".localized
		edgesForExtendedLayout = []
		setupLayout()
		
		navigationController?.setNavigationBarHidden(true, animated: false)
		
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .never
		}
	}
	
	private func setupLayout() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(segmentedControl)
		contentView.addSubview(mailTextField)
		contentView.addSubview(passwordTextField)
		contentView.addSubview(loginButton)
		
		let constraints = UI.getConstraints(for: self)
		NSLayoutConstraint.activate(constraints)
	}
	
	@objc func signIn(_ sender: UIButton) {
		guard let mailValue = mailTextField.text, mailValue != "" else {
			present(UIAlertController.simpleAlert(title: "mail_missing_title".localized, message: nil), animated: true)
			return
		}
		
		guard let passwordValue = passwordTextField.text, passwordValue != "" else {
			present(UIAlertController.simpleAlert(title: "password_missing_title".localized, message: nil), animated: true)
			return
		}
		
		let isCoach = segmentedControl.selectedSegmentIndex == 0
		
		Network.login(mail: mailValue, password: passwordValue, isCoach: false) { [weak self] data, response, _ in
			
			guard let response = response as? HTTPURLResponse,
				let data = data else { return }
			
			print("Status code:", response.statusCode)
			let decoder = JSONDecoder()
			
			if response.statusCode == 200 {
				guard let client = try? decoder.decode(Client.self, from: data) else { return }
				print(client)
				
				let tabBarController = isCoach ? UITabBarController.coachController() : UITabBarController.clientController()
				
				DispatchQueue.main.async {
					self?.present(tabBarController, animated: true) {
						self?.mailTextField.text = ""
						self?.passwordTextField.text = ""
					}
				}
			} else {
				guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
				
				let alertController = UIAlertController.simpleAlert(title: "error".localized, message: errorMessage.message.localized)
				
				DispatchQueue.main.async {
					self?.present(alertController, animated: true)
				}
			}
		}
	}
	
	@objc func signUp(_ sender: UIButton) {
		// Push navigation to future SignUpController
	}
}
