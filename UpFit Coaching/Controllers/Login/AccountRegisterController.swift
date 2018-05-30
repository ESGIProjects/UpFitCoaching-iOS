//
//  AccountRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 21/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class AccountRegisterController: FormViewController {
	
	weak var registerController: RegisterController?
	
	var mailRow: EmailRow!
	var passwordRow: PasswordRow!
	var confirmPasswordRow: PasswordRow!
	var nextRow: ButtonRow!
	
	convenience init(registerController: RegisterController) {
		self.init()
		
		self.registerController = registerController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationOptions = .Disabled
		
		setupLayout()
	}
	
	@objc func next() {
		let validationErrors = form.validate()
		
		if validationErrors.isEmpty {
			
			guard let mail = registerController?.registerBox.mail else { return }
			
			Network.isMailExists(mail: mail) { [weak self] _, response, _ in
				if Network.isSuccess(response: response, successCode: 200) {
					self?.registerController?.goToDetails(.forward)
				} else {
					self?.presentAlert(title: "mail_duplicateError_title".localized, message: "mail_duplicateError_message".localized)
				}
			}
		} else {
			guard let error = validationErrors.first else { return }
			presentAlert(title: error.msg, message: nil)
		}
	}
}
