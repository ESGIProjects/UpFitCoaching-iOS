//
//  EditProfileController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka
import PKHUD

class EditProfileController: FormViewController {
	
	var mailRow: EmailRow!
	var passwordRow: PasswordRow!
	var confirmPasswordRow: PasswordRow!
	var firstNameRow: NameRow!
	var lastNameRow: NameRow!
	var cityRow: TextRow!
	var phoneNumberRow: PhoneRow!
	var addressRow: TextRow?
	
	let currentUser = Database().getCurrentUser()
	
	var mail: String!
	var password: String?
	var firstName: String!
	var lastName: String!
	var city: String!
	var phoneNumber: String!
	var address: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "editProfileController_title".localized
		view.backgroundColor = .white
		
		// Default values
		mail = currentUser?.mail
		password = ""
		firstName = currentUser?.firstName
		lastName = currentUser?.lastName
		city = currentUser?.city
		phoneNumber = currentUser?.phoneNumber
		address = currentUser?.address
		
		setupLayout()
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editProfile))
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	@objc func editProfile() {
		guard let currentUser = currentUser else { return }
		
		let validationErrors = form.validate()
		
		if validationErrors.isEmpty {
			// Parameters construction
			var values = [
				"mail": mail,
				"firstName": firstName,
				"lastName": lastName,
				"city": city,
				"phoneNumber": phoneNumber
			]
			
			if let password = password, password != "" {
				values["password"] = password.sha256()
			}
			
			if let address = address {
				values["address"] = address
			}
			
			guard let parameters = values as? [String: String] else { return }
			
			DispatchQueue.main.async {
				HUD.show(.progress)
			}
			
			Network.updateProfile(for: currentUser, values: parameters) { [weak self] data, response, _ in
				guard let data = data else { return }
				
				if Network.isSuccess(response: response, successCode: 200) {
					// Decode user data
					let decoder = JSONDecoder.withDate
					guard let user = try? decoder.decode(User.self, from: data) else { return }
					
					// Save user
					Database().createOrUpdate(model: user, with: UserObject.init)
					
					// Dismiss form
					self?.navigationController?.dismiss(animated: true)
				} else {
					Network.displayError(self, from: data)
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
