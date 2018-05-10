//
//  DetailsRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class DetailsRegisterController: UIViewController {
	
	var firstNameTextField: UITextField!
	var lastNameTextField: UITextField!
	var cityTextField: UITextField!
	var phoneNumberTextField: UITextField!
	var birthDateTextField: UITextField!
	var addressTextField: UITextField!
	var registerButton: UIButton!

	weak var registerController: RegisterController?
	var type: Int?
	
	convenience init(registerController: RegisterController?, type: Int?) {
		self.init()
		
		self.registerController = registerController
		self.type = type
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLayout()
	}
	
	@objc func register(_ sender: Any?) {
		
		// Verifiy if the first name field is empty
		guard let firstName = firstNameTextField.text, firstName != "" else {
			registerController?.presentAlert(title: "firstName_missing_title".localized, message: nil)
			return
		}
		registerController?.registerBox.firstName = firstName
		
		// Verifiy if the last name field is empty
		guard let lastName = lastNameTextField.text, lastName != "" else {
			registerController?.presentAlert(title: "lastName_missing_title".localized, message: nil)
			return
		}
		registerController?.registerBox.lastName = lastName
		
		// Verifiy if the city field is empty
		guard let city = cityTextField.text, city != "" else {
			registerController?.presentAlert(title: "city_missing_title".localized, message: nil)
			return
		}
		registerController?.registerBox.city = city
		
		// Verifiy if the phone number field is empty
		guard let phoneNumber = phoneNumberTextField.text, phoneNumber != "" else {
			registerController?.presentAlert(title: "phoneNumber_missing_title".localized, message: nil)
			return
		}
		registerController?.registerBox.phoneNumber = phoneNumber
		
		if type == 2 {
			
			guard let address = addressTextField.text, address != "" else {
				registerController?.presentAlert(title: "address_missing_title".localized, message: nil)
				return
			}
			registerController?.registerBox.address = address
			
		} else {
			// TEMPORARY
//			let dateFormatter = DateFormatter()
//			dateFormatter.dateFormat = "yyyy-MM-dd"
//
//			let birthDate = dateFormatter.string(from: detailsController.birthDatePicker.date)
			
			guard let birthDate = birthDateTextField.text, birthDate != "" else {
				registerController?.presentAlert(title: "birthDate_missing_title".localized, message: nil)
				return
			}
			registerController?.registerBox.birthDate = birthDate
			
		}
		
		registerController?.register()
	}
}
