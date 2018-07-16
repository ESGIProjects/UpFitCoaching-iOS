//
//  AccountRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 21/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka
import PKHUD

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
		setupLayout()
	}
	
	@objc func next() {
		let validationErrors = form.validate()
		
		if validationErrors.isEmpty {
			
			guard let mail = registerController?.registerBox.mail else { return }
			
			DispatchQueue.main.async {
				HUD.show(.progress)
			}
			
			Network.isMailExists(mail: mail) { [weak self] _, response, _ in
				if Network.isSuccess(response: response, successCode: 200) {
					self?.registerController?.goToDetails(.forward)
				} else {
					self?.presentAlert(title: "mail_duplicateError_title".localized, message: "mail_duplicateError_message".localized)
				}
				
				DispatchQueue.main.async {
					HUD.hide()
				}
			}
		} else {
			guard let error = validationErrors.first else { return }
			presentAlert(title: error.msg, message: nil)
		}
	}
}
