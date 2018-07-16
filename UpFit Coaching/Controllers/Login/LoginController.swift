//
//  LoginController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import RealmSwift
import CryptoSwift
import PKHUD

struct Login: Codable {
	var token: String
	var user: User
}

class LoginController: UIViewController {
	
	// MARK: - UI
	
	var backgroundImage: UIImageView!
	var scrollView: UIScrollView!
	var contentView: UIView!
	var titleLabel: UILabel!
	var mailTextField: UITextField!
	var passwordTextField: UITextField!
	var loginButton: UIButton!
	var signUpButton: UIButton!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "loginController_title".localized
		edgesForExtendedLayout = []
		
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	// MARK: - Actions
	
	@objc func signIn(_ sender: UIButton) {
		
		// Check if the form is complete
		
		guard let mailValue = mailTextField.text, mailValue != "" else {
			presentAlert(title: "mail_missingTitle".localized, message: nil)
			return
		}
		
		guard let passwordValue = passwordTextField.text, passwordValue != "" else {
			presentAlert(title: "password_missingTitle".localized, message: nil)
			return
		}
		
		guard isMailValid(mailValue) else {
			presentAlert(title: "mail_formatError".localized, message: nil)
			return
		}
		
		// Perform the network call
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
		Network.login(mail: mailValue, password: passwordValue.sha256()) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				
				// Decode user data
				let decoder = JSONDecoder.withDate
				guard let loginInfo = try? decoder.decode(Login.self, from: data) else { return }
				
				UserDefaults.standard.set(loginInfo.token, forKey: "authToken")
				print("User ID", loginInfo.user.userID)
				
				self?.processLogin(for: loginInfo.user) {
					self?.mailTextField.text = ""
					self?.passwordTextField.text = ""
				}
			} else {
				Network.displayError(self, from: data)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	@objc func signUp(_ sender: UIButton) {
		navigationController?.pushViewController(RegisterController(), animated: true)
	}
	
	private func isMailValid(_ mail: String) -> Bool {
			return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
				.evaluate(with: mail)
	}
}
