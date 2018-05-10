//
//  AccountRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class AccountRegisterController: UIViewController {
	
	var mailTextField: UITextField!
	var passwordTextField: UITextField!
	var confirmPasswordTextField: UITextField!
	var nextButton: UIButton!
	
	weak var registerController: RegisterController?
	
	convenience init(registerController: RegisterController?) {
		self.init()
		self.registerController = registerController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLayout()
	}
	
	@objc func next(_ sender: Any?) {
		guard let mail = mailTextField.text, mail != "" else {
			registerController?.presentAlert(title: "mail_missing_title".localized, message: nil)
			return
		}
		registerController?.registerBox.mail = mail
		
		guard let password = passwordTextField.text, password != "" else {
			registerController?.presentAlert(title: "password_missing_title".localized, message: nil)
			return
		}
		registerController?.registerBox.password = password.sha256()
		
		guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
			registerController?.presentAlert(title: "confirmPassword_error_title".localized, message: nil)
			return
		}
		
		registerController?.goToDetails(.forward)
	}
}
