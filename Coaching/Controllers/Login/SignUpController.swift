//
//  SignUpController.swift
//  Coaching
//
//  Created by Jason Pierna on 11/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
	
	lazy var scrollView = UI.scrollView()
	lazy var contentView = UI.contentView()
	lazy var firstNameTextField = UI.firstNameTextField()
	lazy var lastNameTextField = UI.lastNameTextField()
	lazy var mailTextField = UI.mailTextField()
	lazy var passwordTextField = UI.passwordTextField()
	lazy var confirmPasswordTextField = UI.confirmPasswordTextField()
	lazy var birthDatePicker = UI.birthDatePicker()
	lazy var signUpButton = UI.signUpButton(self, action: #selector(signUp(_:)))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "signUpController_title".localized
		view.backgroundColor = .white
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func setupLayout() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(firstNameTextField)
		contentView.addSubview(lastNameTextField)
		contentView.addSubview(mailTextField)
		contentView.addSubview(passwordTextField)
		contentView.addSubview(confirmPasswordTextField)
		contentView.addSubview(birthDatePicker)
		contentView.addSubview(signUpButton)
		
		let constraints = UI.getConstraints(for: self)
		NSLayoutConstraint.activate(constraints)
	}
	
	@objc func signUp(_ sender: UIButton) {
		guard let firstName = firstNameTextField.text, firstName != "" else {
			present(UIAlertController.simpleAlert(title: "firstName_missing_title".localized, message: nil), animated: true)
			return
		}
		
		guard let lastName = lastNameTextField.text, lastName != "" else {
			present(UIAlertController.simpleAlert(title: "lastName_missing_title".localized, message: nil), animated: true)
			return
		}
		
		guard let mail = mailTextField.text, mail != "" else {
			present(UIAlertController.simpleAlert(title: "mail_missing_title".localized, message: nil), animated: true)
			return
		}
		
		guard let password = passwordTextField.text, password != "" else {
			present(UIAlertController.simpleAlert(title: "password_missing_title".localized, message: nil), animated: true)
			return
		}
		
		guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
			present(UIAlertController.simpleAlert(title: "confirmPassword_error_title".localized, message: nil), animated: true)
			return
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		let birthDate = dateFormatter.string(from: birthDatePicker.date)
		
		Network.register(mail: mail, password: password, type: 1, firstName: firstName, lastName: lastName, birthDate: birthDate, city: "Paris", phoneNumber: "118218") { [weak self] data, response, _ in
			
			guard let response = response as? HTTPURLResponse,
				let data = data else { return }
			
			print("Status code:", response.statusCode)
			let decoder = JSONDecoder()
			
			if response.statusCode == 201 {
				
			} else {
				guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
				
				let alertController = UIAlertController.simpleAlert(title: "error".localized, message: errorMessage.message.localized)
				
				DispatchQueue.main.async {
					self?.present(alertController, animated: true)
				}
			}
		}
	}
}
