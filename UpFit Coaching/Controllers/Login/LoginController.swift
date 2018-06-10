//
//  LoginController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import RealmSwift
import CryptoSwift
import PKHUD

class LoginController: UIViewController {
	
	// MARK: - UI
	
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
		
		// Perform the network call
		HUD.show(.progress)
		
		Network.login(mail: mailValue, password: passwordValue.sha256()) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode user data
				let decoder = JSONDecoder.withDate
				guard let user = try? decoder.decode(User.self, from: data) else { return }
				
				print("User ID", user.userID)
				
				self?.processLogin(for: user) {
					self?.mailTextField.text = ""
					self?.passwordTextField.text = ""
				}
			} else {
				Network.displayError(self, from: data)
			}
			
			HUD.hide()
		}
	}
	
	@objc func signUp(_ sender: UIButton) {
		navigationController?.pushViewController(RegisterController(), animated: true)
	}
}
